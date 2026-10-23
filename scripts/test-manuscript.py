"""Focused manuscript generation tests; no analyses or publication writes."""
import importlib.util
from pathlib import Path
import unittest
import os
import ast
import re
import csv
import tempfile

spec = importlib.util.spec_from_file_location('builder', Path(__file__).with_name('build-manuscript.py'))
builder = importlib.util.module_from_spec(spec)
spec.loader.exec_module(builder)


class ManuscriptStructure(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        manuscript_dir = Path(__file__).resolve().parents[1] / 'docs/manuscript'
        spec = importlib.util.spec_from_file_location('numbers', manuscript_dir / 'verify-numbers.py')
        cls.numbers = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(cls.numbers)
        # Load the actual formatting helpers without executing the publication build.
        from docx import Document
        from docx.oxml import OxmlElement
        from docx.oxml.ns import qn
        from docx.shared import Pt
        from docx.text.paragraph import Paragraph
        path = manuscript_dir / 'assemble-publication.py'
        tree = ast.parse(path.read_text(), filename=str(path))
        helpers = ast.Module(body=[node for node in tree.body if isinstance(node, ast.FunctionDef)
                                  and node.name in {'format_abstract', 'bind_reporting_reference'}], type_ignores=[])
        cls.formatting = dict(re=re, OxmlElement=OxmlElement, qn=qn, Pt=Pt, Paragraph=Paragraph)
        exec(compile(helpers, str(path), 'exec'), cls.formatting)
        cls.document = staticmethod(Document)

    def test_repeated_abstract_and_body_headings_are_scoped(self):
        text = ('# Title\n\n## Front-matter notes\n\n## Abstract\n'
                '### Objective\n\nAim.\n\n### Materials and Methods\n\nDesign.\n'
                '### Results\n\nFinding.\n\n### Discussion\n\nAbstract interpretation.\n'
                '### Conclusion\n\nAbstract conclusion.\n\n## Introduction\n'
                '### Background and significance\n\nContext.\n\n### Objective\n\nQuestion.\n'
                '## Materials and methods\n\nMethods.\n\n## Results\n\nResults.\n'
                '## Discussion\n\nBody interpretation.\n\n### Conclusion\n\nBody conclusion.\n'
                '## Back matter\n\nDeclarations.\n')
        self.assertEqual(self.numbers.structure_checks(text), [])
        counts, total = self.numbers.word_counts(text)
        self.assertEqual((counts['Abstract'], counts['Introduction'], counts['Discussion'], total), (7, 2, 4, 8))
        self.assertTrue(any('Introduction heading mismatch' in failure for failure in
                            self.numbers.structure_checks(text.replace('### Background and significance', '### Background'))))
        doc = self.document()
        for heading, style in [('ABSTRACT', 'Heading 1'), ('Discussion', 'Heading 2'),
                               ('Conclusion', 'Heading 2'), ('INTRODUCTION', 'Heading 1'),
                               ('Background and significance', 'Heading 2'), ('Objective', 'Heading 2'),
                               ('DISCUSSION', 'Heading 1'), ('Conclusion', 'Heading 2')]:
            doc.add_paragraph(heading, style)
            doc.add_paragraph('Prose.')
        self.formatting['format_abstract'](doc)
        self.assertEqual([p.text for p in doc.paragraphs if p.style.name == 'Heading 2'],
                         ['Background and significance', 'Objective', 'Conclusion'])
        self.assertEqual([p.text for p in doc.paragraphs if p.text.endswith('. Prose.')],
                         ['Discussion. Prose.', 'Conclusion. Prose.'])

    def test_reporting_reference_binding_survives_renumbering_and_run_split(self):
        doc = self.document()
        p = doc.add_paragraph('Reporting was guided by TRIPOD-LLM and GRRAS, with author-completion fields.')
        p.add_run('[24,25]')
        self.formatting['bind_reporting_reference'](p)
        self.assertTrue(p.text.endswith('fields.\u2060[24,25]'))
        other = doc.add_paragraph('Unrelated fields.[24,25]')
        self.formatting['bind_reporting_reference'](other)
        self.assertEqual(other.text, 'Unrelated fields.[24,25]')

    def test_command_metadata_does_not_exempt_adjacent_study_numbers(self):
        text = '`/rob2-assess` 987654321 /rob3-assess'
        spans = self.numbers.metadata_spans(text)
        classified = [m.group() for m in self.numbers.NUMBER.finditer(text)
                      if any(start <= m.start() < end for start, end, _ in spans)]
        self.assertEqual(classified, ['2'])

    def test_search_year_metadata_is_limited_to_eligibility_statement(self):
        text = 'Europe PMC for 2025–2026 meta-analyses; 2025 assessments and 2026 results.'
        spans = self.numbers.metadata_spans(text)
        classified = [m.group() for m in self.numbers.NUMBER.finditer(text)
                      if any(start <= m.start() < end for start, end, _ in spans)]
        self.assertEqual(classified, ['2025', '2026'])


class ExternalClaimLedger(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        path = Path(__file__).resolve().parents[1] / 'docs/manuscript/verify-numbers.py'
        spec = importlib.util.spec_from_file_location('external_numbers', path)
        cls.audit = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(cls.audit)

    def setUp(self):
        self.claim = 'Minozzi reported 70 outcomes and κ 0.16 (95% CI, 0.08–0.24).[2]'
        self.text = f'## Introduction\n\n{self.claim}\n\n## Results\n\nARBITER matched 53/60.\n'
        self.refs = '1. Other. doi:10.1234/other.\n\n2. Minozzi. doi:[10.1016/j.jclinepi.2020.06.015](https://doi.org/10.1016/j.jclinepi.2020.06.015).\n'
        self.row = dict(id='M20', exact_text=self.claim, reference='2',
                        doi='10.1016/j.jclinepi.2020.06.015',
                        metric_context='Overall Fleiss kappa; four raters, 70 outcomes',
                        locator='Abstract Results, p.37', access_level='Primary abstract inspected',
                        boundary='Not pairwise weighted kappa or an ARBITER comparison')

    def validate(self, text=None, rows=None, refs=None):
        with tempfile.TemporaryDirectory() as directory:
            ledger = Path(directory) / 'external-facts.tsv'
            with ledger.open('w', newline='') as handle:
                writer = csv.DictWriter(handle, fieldnames=sorted(self.audit.EXTERNAL_COLUMNS), delimiter='\t')
                writer.writeheader()
                writer.writerows([self.row] if rows is None else rows)
            return self.audit.external_claim_checks(self.text if text is None else text,
                                                    self.refs if refs is None else refs, ledger)

    def test_exact_context_and_source_identity_classify_separately(self):
        spans, failures = self.validate()
        self.assertEqual(failures, [])
        index = {self.audit.normal(n): {'study.csv:2:count'}
                 for n in ('70', '0.16', '0.08', '0.24', '53', '60')}
        traced, external, metadata, missing = self.audit.classify_numbers(self.text, index, spans)
        self.assertEqual([t for _, t, _ in traced], ['53', '60'])
        self.assertEqual([t for _, t, _ in external], ['70', '0.16', '0.08', '0.24'])
        self.assertEqual(missing, [])
        self.assertTrue(any('reference 2; doi:' in source for _, _, source in external))

    def test_external_numeric_and_narrative_mutations_fail_even_if_in_csv(self):
        for text in (self.text.replace('70 outcomes', '60 outcomes'),
                     self.text.replace('reported', 'confirmed')):
            with self.subTest(text=text):
                spans, failures = self.validate(text=text)
                self.assertTrue(any('occurrence count 0' in f for f in failures))
                index = {self.audit.normal(m[0]): {'study.csv'} for m in self.audit.NUMBER.finditer(text)}
                traced, external, _, missing = self.audit.classify_numbers(text, index, spans)
                self.assertEqual(external, [])
                self.assertTrue(any(t == '0.16' for _, t, _ in missing))
                self.assertEqual([t for _, t, _ in traced], ['53', '60'])

    def test_missing_ledger_row_cannot_use_csv_for_literature(self):
        spans, failures = self.validate(rows=[])
        self.assertEqual(failures, [])
        classified = self.audit.classify_numbers(self.text, {'70': {'study.csv'}}, spans)
        self.assertIn('70', [t for _, t, _ in classified[3]])

    def test_citation_mismatch_and_bibliographic_identity_change(self):
        for row, refs in ((dict(self.row, reference='1'), self.refs),
                          (self.row, self.refs.replace(self.row['doi'], '10.1234/replaced')),
                          (dict(self.row, doi='https://doi.org/' + self.row['doi']), self.refs)):
            with self.subTest(row=row, refs=refs):
                spans, failures = self.validate(rows=[row], refs=refs)
                self.assertEqual(spans, [])
                self.assertTrue(failures)
        changed = self.text.replace('.[2]', '.[1]')
        self.assertTrue(self.validate(text=changed)[1])

    def test_each_source_metadata_field_is_required(self):
        for field in self.audit.EXTERNAL_COLUMNS:
            with self.subTest(field=field):
                spans, failures = self.validate(rows=[dict(self.row, **{field: ''})])
                self.assertEqual(spans, [])
                self.assertTrue(any('missing source metadata' in f for f in failures))

    def test_no_global_numeric_whitelist_or_ambiguous_occurrence(self):
        for exact in ('70', '.*70.*', self.claim + '\n'):
            self.assertTrue(self.validate(rows=[dict(self.row, exact_text=exact)])[1])
        self.assertTrue(any('occurrence count 2' in f for f in
                            self.validate(text=self.text + self.claim)[1]))
        self.assertTrue(any('duplicate' in f for f in self.validate(rows=[self.row, self.row])[1]))

    def test_statistical_number_cannot_be_waived_by_external_span(self):
        claim = 'ARBITER matched 53/60.[2]'
        row = dict(self.row, exact_text=claim)
        for section in ('Introduction', 'Results', 'Discussion', 'Abstract'):
            text = f'## {section}\n\n{claim}\n'
            spans, failures = self.validate(text=text, rows=[row])
            self.assertEqual(spans, [])
            self.assertTrue(any('own-study numeric' in f for f in failures))
            self.assertEqual([t for _, t, _ in self.audit.classify_numbers(text, {}, spans)[3]], ['53', '60'])
        # A valid literature row never exempts an adjacent own-study number.
        text = self.text.replace('53/60', '999999/60')
        spans, failures = self.validate(text=text)
        self.assertEqual(failures, [])
        self.assertIn('999999', [t for _, t, _ in self.audit.classify_numbers(text, {}, spans)[3]])

    def test_original_row_bound_headline_guard_remains_independent(self):
        # All required source rows are read from committed outputs. The small
        # prose fixture isolates the original primary count assertion.
        text = ('## Abstract\n\n53/60 and 7/60.\n\n'
                '## Materials and methods\n\nDefinitions.\n')
        self.assertNotIn('Primary counts missing', self.audit.headline_checks(text))
        self.assertIn('Primary counts missing',
                      self.audit.headline_checks(text.replace('53/60', '52/60')))

    def test_equivalent_endpoint_wording_retains_all_conditions(self):
        original = ("### Outcomes\nAcross all 510 cells. "
                    "The denominator included only cells in which both experts chose the same label "
                    "among cells where the arms' ratings differed.")
        revised = ("### Outcomes\nFor Published, paired differences across 510 cells. "
                   "The conditional label-choice analysis included the cells where the arms differed and both experts chose the same label. "
                   "Its numerator counted agreed labels matching ARBITER.")
        self.assertEqual(self.audit.endpoint_definition_checks(original), [])
        self.assertEqual(self.audit.endpoint_definition_checks(revised), [])
        for before, after in (('510', '60'), ('arms differed', 'arms agreed'),
                              ('both experts', 'one expert'), ('matching ARBITER', 'matching Unassisted')):
            with self.subTest(before=before):
                self.assertTrue(self.audit.endpoint_definition_checks(revised.replace(before, after)))

    def test_missing_ledger_and_schema_fail_closed(self):
        with tempfile.TemporaryDirectory() as directory:
            ledger = Path(directory) / 'external-facts.tsv'
            self.assertTrue(self.audit.external_claim_checks(self.text, self.refs, ledger)[1])
            ledger.write_text('id\texact_text\nM20\t70\n')
            spans, failures = self.audit.external_claim_checks(self.text, self.refs, ledger)
            self.assertEqual(spans, [])
            self.assertTrue(any('missing required columns' in f for f in failures))
            ledger.write_text('id\tid\nM20\tM22\n')
            self.assertTrue(any('duplicate column' in f for f in
                                self.audit.external_claim_checks(self.text, self.refs, ledger)[1]))

    def test_integrated_ledger_matches_manuscript_and_bibliography(self):
        if not self.audit.EXTERNAL_FACTS.exists():
            self.skipTest('Integration-owned external ledger not yet present')
        spans, failures = self.audit.external_claim_checks(
            self.audit.MANUSCRIPT.read_text(), self.audit.REFERENCES.read_text())
        self.assertEqual(failures, [])
        self.assertTrue(spans, 'Integrated literature must have context-bound provenance')

    def test_external_fact_cannot_be_moved_into_study_results(self):
        spans, failures = self.validate(text='## Results\n\n' + self.claim)
        self.assertEqual(spans, [])
        self.assertTrue(any('Introduction or Discussion' in f for f in failures))

    def test_mixed_group_cannot_waive_own_study_sentence(self):
        claim = self.claim + ' ARBITER matched 53/60.'
        spans, failures = self.validate(text='## Discussion\n\n' + claim,
                                        rows=[dict(self.row, exact_text=claim)])
        self.assertEqual(spans, [])
        self.assertTrue(any('own-study numeric' in f for f in failures))

    def test_known_gandhi_source_context_correction_is_protected(self):
        row = dict(self.row, metric_context='ophthalmic surgical research assessors')
        self.assertTrue(any('Gandhi OSRA expansion' in f for f in self.validate(rows=[row])[1]))
        row['metric_context'] = 'original systematic review authors'
        self.assertEqual(self.validate(rows=[row])[1], [])

    def test_literature_wording_exceptions_do_not_allow_priority_claims(self):
        text = 'The first five studies used a masked panel with 70 outcomes.[2]'
        spans = [(0, len(text), 'validated ledger fixture')]
        self.assertEqual(self.audit.wording_checks(text, spans), [])
        self.assertTrue(self.audit.wording_checks(text, []))
        self.assertTrue(self.audit.wording_checks(text + ' ARBITER is the first tool.', spans))
        self.assertTrue(self.audit.wording_checks(text.replace('masked', 'ground truth'),
                                                [(0, 1000, 'fixture')]))

    def test_group_must_cover_whole_sentences_and_support_citation_ranges(self):
        claim = 'Four raters assessed 70 outcomes. Overall κ was 0.16.[1–2]'
        self.assertEqual(self.validate(text='## Introduction\n\n' + claim,
                                      rows=[dict(self.row, exact_text=claim)])[1], [])
        self.assertTrue(any('complete sentence' in f for f in
                            self.validate(rows=[dict(self.row, exact_text=self.claim[8:])])[1]))


class ManuscriptPage(unittest.TestCase):
    def setUp(self):
        self.text = '# Article\n\n## Abstract\n\nFull abstract.\n\nTable 1 and Table 2 appear together.\n\nLater Table 3.\n\n# References\n\n1. Complete reference.'
        self.tables = [f'<table><tr><td>cell {i}</td></tr></table>' for i in range(1, 4)]
        self.legends = [(f'Figure {i}. Legend <tag>.', 'Alt "quoted" & text') for i in range(1, 6)]

    def test_full_text_and_references_preserved_once(self):
        page = builder.manuscript_page(self.text, self.tables, self.legends)
        for paragraph in self.text.split('\n\n'):
            self.assertEqual(page.count(paragraph), 1)
        self.assertEqual(page.count('<table>'), 3)
        self.assertEqual(page.count('<figure '), 5)
        self.assertIn('alt="Alt &quot;quoted&quot; &amp; text"', page)
        self.assertIn('Legend &lt;tag&gt;.', page)
        for i in range(1, 6):
            self.assertIn(f'output/manuscript/Figure{i}.png', page)
            self.assertIn(f'output/manuscript/Figure{i}.pdf', page)

    def test_tables_follow_first_citation(self):
        page = builder.manuscript_page(self.text, self.tables, self.legends)
        self.assertLess(page.index('Table 1 and Table 2'), page.index('cell 1'))
        self.assertLess(page.index('cell 1'), page.index('cell 2'))
        self.assertLess(page.index('cell 2'), page.index('Later Table 3'))
        self.assertLess(page.index('cell 3'), page.index('# References'))

    def test_missing_table_citation_fails(self):
        with self.assertRaisesRegex(ValueError, 'Table 3 citation'):
            builder.manuscript_page(self.text.replace('Table 3', 'table three'), self.tables, self.legends)

    def test_legend_inventory_and_explicit_alt(self):
        text = '\n\n'.join(f'Figure {i}. Caption.\n\nAlt text: Actual alt {i}.' for i in range(1, 6))
        self.assertEqual(builder.metadata.main_legends(text)[3], ('Figure 4. Caption.', 'Actual alt 4.'))
        with self.assertRaisesRegex(ValueError, 'five ordered'):
            builder.metadata.main_legends(text.replace('Figure 3.', 'Figure 4.'))


@unittest.skipUnless(os.environ.get('ARBITER_CHECK_BUILT') == '1', 'Set ARBITER_CHECK_BUILT=1 after building the manuscript.')
class BuiltManuscript(unittest.TestCase):
    def test_final_cells_images_and_unique_anchors(self):
        from docx import Document
        from lxml import html
        page = html.parse(str(builder.ANALYSIS / 'manuscript.html'))
        normalize = lambda s: ' '.join(s.split())
        tables = page.xpath('//section[@class="manuscript-table"]//table')
        self.assertEqual(len(tables), 3)
        for i, table in enumerate(tables, 1):
            actual = [normalize(''.join(c.itertext())) for c in table.xpath('.//tr/*[self::td or self::th]')]
            expected = [normalize(' '.join(''.join(p.itertext('{http://schemas.openxmlformats.org/wordprocessingml/2006/main}t')) for p in c.xpath('./w:p'))) for c in Document(builder.OUT / f'Table{i}.docx').tables[0]._tbl.xpath('./w:tr/w:tc')]
            self.assertEqual(actual, expected, f'Table {i} physical cells and notes')
        images = page.xpath('//figure[contains(@class,"manuscript-figure")]//img')
        self.assertEqual(len(images), 5)
        self.assertTrue(all(im.get('alt') and im.get('src').startswith('data:image/') for im in images))
        ids = page.xpath('//@id')
        self.assertEqual(len(ids), len(set(ids)), 'Duplicate contents destinations')


if __name__ == '__main__':
    unittest.main()
