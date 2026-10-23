"""Focused manuscript generation tests; no analyses or publication writes."""
import importlib.util
from pathlib import Path
import unittest
import os

spec = importlib.util.spec_from_file_location('builder', Path(__file__).with_name('build-manuscript.py'))
builder = importlib.util.module_from_spec(spec)
spec.loader.exec_module(builder)


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
