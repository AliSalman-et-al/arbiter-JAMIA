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

    def test_old_manifest_without_manuscript_is_rejected(self):
        with self.assertRaisesRegex(RuntimeError, "lacks required files.*manuscript.html"):
            verifier.verify('https://example.org', {'files': {}})

    def test_changed_manuscript_is_rejected(self):
        files = ['index.html', 'manuscript.html', 'results.html', 'supplement.html', 'output/manuscript/Manuscript.docx']
        expected = {'source_commit': 'sha', 'files': {name: {'bytes': 4, 'sha256': hashlib.sha256(b'good').hexdigest()} for name in files}}
        def fetch(url):
            if 'publication-manifest.json' in url:
                return json.dumps(expected).encode()
            return b'evil' if '/manuscript.html?' in url else b'good'
        with patch.object(verifier, 'fetch', side_effect=fetch):
            with self.assertRaisesRegex(RuntimeError, 'differs from staged release: manuscript.html'):
                verifier.verify('https://example.org', expected)


class PublicationLinks(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.root = Path(self.directory.name).resolve()
        for name in ("index.html", "manuscript.html", "results.html", "supplement.html"):
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

    def test_manuscript_missing_word_download_fails(self):
        (self.root / "manuscript.html").write_text('<a href="output/manuscript/Manuscript.docx">Word</a>', encoding="utf-8")
        with self.assertRaisesRegex(SystemExit, "manuscript.html: output/manuscript/Manuscript.docx"):
            pages.check_links(self.root)

    def test_missing_manuscript_page_fails(self):
        (self.root / "manuscript.html").unlink()
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
        navigation = b'<nav id="publication-navigation">\r\n<a href="manuscript.html">Manuscript</a>\r\n</nav>'
        (project / 'scripts/publication-nav.html').write_bytes(navigation)
        for relative in ['scripts/pages-index.html', 'analysis/manuscript.html', 'analysis/results.html', 'analysis/supplement.html']:
            (project / relative).write_bytes(html)
        binary = b'binary\r\n\x00content'
        names = [f'{stem}.docx' for stem in ['Manuscript', 'Supplement', 'TRIPOD-LLM', 'Table1', 'Table2', 'Table3']]
        names += [f'Figure{i}.{ext}' for i in range(1, 6) for ext in ['pdf', 'png']]
        for name in names:
            (output / name).write_bytes(binary)
        destination = self.root / 'release'
        destination.mkdir()
        retired = destination / 'eFigure-retired.png'
        retired.write_bytes(b'old managed artwork')
        unmanaged = destination / 'personal-note.txt'
        unmanaged.write_text('unmanaged')
        (destination / 'publication-manifest.json').write_text(json.dumps({'files': {retired.name: {}}}))
        with patch.object(pages, 'ROOT', project), patch.object(pages.subprocess, 'check_output', return_value='source-sha\n'):
            pages.stage(destination)
        self.assertFalse(retired.exists())
        self.assertEqual(unmanaged.read_text(), 'unmanaged')
        manifest = json.loads((destination / 'publication-manifest.json').read_text())
        self.assertEqual((destination / 'results.html').read_bytes(), html.replace(b'\r\n', b'\n').replace(b'<body>', b'<body>\n' + navigation.replace(b'\r\n', b'\n')))
        self.assertEqual((destination / 'manuscript.html').read_bytes().count(b'id="publication-navigation"'), 1)
        self.assertEqual((destination / 'output/manuscript/Manuscript.docx').read_bytes(), binary)
        self.assertIn('manuscript.html', manifest['files'])
        for relative, expected in manifest['files'].items():
            body = (destination / relative).read_bytes()
            self.assertEqual(expected, {'bytes': len(body), 'sha256': hashlib.sha256(body).hexdigest()})


if __name__ == "__main__":
    unittest.main()
