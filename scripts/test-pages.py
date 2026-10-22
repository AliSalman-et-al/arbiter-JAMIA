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

    def test_workspace_cannot_be_staging_destination(self):
        with self.assertRaisesRegex(SystemExit, "dedicated Pages"):
            pages.stage(pages.ROOT)

    def test_manifest_matches_git_text_bytes_and_preserves_binary_downloads(self):
        project = self.root / 'project'
        output = project / 'analysis/output/manuscript'
        output.mkdir(parents=True)
        (project / 'scripts').mkdir()
        html = b'<p>Report</p>\r\n<p>Second line</p>\r\n'
        for relative in ['scripts/pages-index.html', 'analysis/results.html', 'analysis/supplement.html']:
            (project / relative).write_bytes(html)
        binary = b'binary\r\n\x00content'
        names = [f'{stem}.docx' for stem in ['Manuscript', 'Supplement', 'TRIPOD-LLM', 'Table1', 'Table2', 'Table3']]
        names += [f'Figure{i}.{ext}' for i in range(1, 6) for ext in ['pdf', 'png']]
        for name in names:
            (output / name).write_bytes(binary)
        destination = self.root / 'release'
        with patch.object(pages, 'ROOT', project), patch.object(pages.subprocess, 'check_output', return_value='source-sha\n'):
            pages.stage(destination)
        manifest = json.loads((destination / 'publication-manifest.json').read_text())
        self.assertEqual((destination / 'results.html').read_bytes(), html.replace(b'\r\n', b'\n'))
        self.assertEqual((destination / 'output/manuscript/Manuscript.docx').read_bytes(), binary)
        for relative, expected in manifest['files'].items():
            body = (destination / relative).read_bytes()
            self.assertEqual(expected, {'bytes': len(body), 'sha256': hashlib.sha256(body).hexdigest()})


if __name__ == "__main__":
    unittest.main()
