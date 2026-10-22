"""Focused checks for publication-package links and path containment."""
import importlib.util
from pathlib import Path
import tempfile
import unittest

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


if __name__ == "__main__":
    unittest.main()
