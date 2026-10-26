"""Focused checks for publication-package links and path containment."""
import importlib.util
import hashlib
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

spec = importlib.util.spec_from_file_location("stage_pages", Path(__file__).with_name("stage-pages.py"))
pages = importlib.util.module_from_spec(spec)
spec.loader.exec_module(pages)

verify_spec = importlib.util.spec_from_file_location("verify_pages", Path(__file__).with_name("verify-pages.py"))
verifier = importlib.util.module_from_spec(verify_spec)
verify_spec.loader.exec_module(verifier)


class PublicationVerification(unittest.TestCase):
    def test_main_inventory_and_current_worked_example_links(self):
        self.assertEqual((pages.metadata.MAIN_FIGURE_COUNT,pages.metadata.MAIN_TABLE_COUNT),(5,3))
        self.assertEqual(len(pages.metadata.WORKED_EXAMPLE_LINKS),2)
        for label,url in pages.metadata.WORKED_EXAMPLE_LINKS:
            relative=url.split('/blob/main/',1)[1]
            self.assertTrue((pages.ROOT/relative).is_file(),label)

    def test_manifest_without_analysis_is_rejected(self):
        with self.assertRaisesRegex(RuntimeError, "lacks required files.*results.html"):
            verifier.verify('https://example.org', {'files': {}})

    def test_changed_analysis_is_rejected(self):
        files = ['index.html', 'results.html', 'supplement.html', 'output/manuscript/Supplement.docx', 'output/manuscript/Main-analysis.docx']
        expected = {'source_commit': 'sha', 'files': {name: {'bytes': 4, 'sha256': hashlib.sha256(b'good').hexdigest()} for name in files}}
        def fetch(url):
            if 'publication-manifest.json' in url:
                return json.dumps(expected).encode()
            return b'evil' if '/results.html?' in url else b'good'
        with patch.object(verifier, 'fetch', side_effect=fetch):
            with self.assertRaisesRegex(RuntimeError, 'differs from staged release: results.html'):
                verifier.verify('https://example.org', expected)


class PublicationLinks(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.root = Path(self.directory.name).resolve()
        for name in ("index.html", "results.html", "supplement.html"):
            (self.root / name).write_text('<a href="https://example.org">External</a><img src="data:image/png;base64,AA">', encoding="utf-8")

    def tearDown(self):
        self.directory.cleanup()

    def test_download_and_fragment_link(self):
        (self.root / "table.docx").write_bytes(b"document")
        (self.root / "results.html").write_text('<a href="table.docx">Word</a><a href="#table">Table</a><a href="supplement.html#methods">Methods</a>', encoding="utf-8")
        self.assertEqual(pages.check_links(self.root), 2)

    def test_missing_download_fails(self):
        (self.root / "results.html").write_text('<a href="output/manuscript/Table1.docx">Word</a>', encoding="utf-8")
        with self.assertRaisesRegex(SystemExit, r"results.html: output/manuscript/Table1.docx"):
            pages.check_links(self.root)

    def test_link_cannot_escape_package(self):
        (self.root / "supplement.html").write_text('<a href="../private.txt">Bad link</a>', encoding="utf-8")
        with self.assertRaisesRegex(SystemExit, r"supplement.html: ../private.txt"):
            pages.check_links(self.root)

    def test_supplement_missing_word_download_fails(self):
        (self.root / "supplement.html").write_text('<a href="output/manuscript/Supplement.docx">Word</a>', encoding="utf-8")
        with self.assertRaisesRegex(SystemExit, "supplement.html: output/manuscript/Supplement.docx"):
            pages.check_links(self.root)

    def test_missing_analysis_page_fails(self):
        (self.root / "results.html").unlink()
        with self.assertRaises(FileNotFoundError):
            pages.check_links(self.root)

    def test_workspace_cannot_be_staging_destination(self):
        with self.assertRaisesRegex(SystemExit, "dedicated Pages"):
            pages.stage(pages.ROOT)

    def test_manifest_matches_git_text_bytes_and_preserves_binary_downloads(self):
        project = self.root / 'project'
        output = project / 'analysis/output/manuscript'
        output.mkdir(parents=True)
        (project / 'scripts').mkdir()
        html = b'<body>\r\n<p>Report</p>\r\n<p>Second line</p>\r\n</body>'
        navigation = b'<nav id="publication-navigation">\r\n<a href="results.html">Main analysis</a>\r\n</nav>'
        (project / 'scripts/publication-nav.html').write_bytes(navigation)
        for relative in ['scripts/pages-index.html', 'analysis/results.html', 'analysis/supplement.html']:
            (project / relative).write_bytes(html)
        binary = b'binary\r\n\x00content'
        names = [f'{stem}.docx' for stem in ['Main-analysis', 'Supplement', 'TRIPOD-LLM', 'Table1', 'Table2', 'Table3']]
        names += [f'Figure{i}.{ext}' for i in range(1, 6) for ext in ['pdf', 'png']]
        for name in names:
            (output / name).write_bytes(binary)
        destination = self.root / 'release'
        destination.mkdir()
        retired = [destination / name for name in ['manuscript.html', 'output/manuscript/Manuscript.docx', 'eFigure-retired.png']]
        for path in retired:
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_bytes(b'old managed content')
        unmanaged = destination / 'personal-note.txt'
        unmanaged.write_text('unmanaged')
        (destination / 'publication-manifest.json').write_text(json.dumps({'files': {path.relative_to(destination).as_posix(): {} for path in retired}}))
        with patch.object(pages, 'ROOT', project), patch.object(pages.subprocess, 'check_output', return_value='source-sha\n'):
            pages.stage(destination)
        self.assertTrue(all(not path.exists() for path in retired))
        self.assertEqual(unmanaged.read_text(), 'unmanaged')
        manifest = json.loads((destination / 'publication-manifest.json').read_text())
        self.assertEqual((destination / 'results.html').read_bytes(), html.replace(b'\r\n', b'\n').replace(b'<body>', b'<body>\n' + navigation.replace(b'\r\n', b'\n')))
        self.assertEqual((destination / 'results.html').read_bytes().count(b'id="publication-navigation"'), 1)
        self.assertEqual((destination / 'output/manuscript/Supplement.docx').read_bytes(), binary)
        self.assertIn('results.html', manifest['files'])
        self.assertIn('output/manuscript/Main-analysis.docx', manifest['files'])
        self.assertNotIn('manuscript.html', manifest['files'])
        self.assertNotIn('output/manuscript/Manuscript.docx', manifest['files'])
        for relative, expected in manifest['files'].items():
            body = (destination / relative).read_bytes()
            self.assertEqual(expected, {'bytes': len(body), 'sha256': hashlib.sha256(body).hexdigest()})


if __name__ == "__main__":
    unittest.main()
