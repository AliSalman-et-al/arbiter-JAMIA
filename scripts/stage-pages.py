"""Stage the public reports and their downloads, then check every local link."""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
from html.parser import HTMLParser
import json
import re
from pathlib import Path
import shutil
import subprocess
from urllib.parse import unquote, urlsplit

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location('manuscript_sources', Path(__file__).with_name('manuscript-sources.py'))
metadata = importlib.util.module_from_spec(spec)
spec.loader.exec_module(metadata)


class Links(HTMLParser):
    def __init__(self):
        super().__init__()
        self.local = set()

    def handle_starttag(self, tag, attrs):
        for key, value in attrs:
            if key not in {"href", "src"} or not value:
                continue
            parts = urlsplit(value)
            if not parts.scheme and not parts.netloc and parts.path:
                self.local.add(unquote(parts.path))


def check_links(destination: Path):
    failures = []
    checked = 0
    for filename in ("index.html", "results.html", "supplement.html"):
        parser = Links()
        parser.feed((destination / filename).read_text(encoding="utf-8"))
        for link in sorted(parser.local):
            target = (destination / link).resolve()
            if not target.is_relative_to(destination) or not target.is_file():
                failures.append(f"{filename}: {link}")
            checked += 1
    if failures:
        raise SystemExit("Missing or out-of-package links:\n" + "\n".join(failures))
    return checked


def stage(destination: Path):
    destination = destination.resolve()
    if destination == ROOT or ROOT.is_relative_to(destination):
        raise SystemExit("Choose a dedicated Pages worktree or staging directory.")
    sources = {
        "index.html": ROOT / "scripts/pages-index.html",
        "results.html": ROOT / "analysis/results.html",
        "supplement.html": ROOT / "analysis/supplement.html",
    }
    output = ROOT / "analysis/output/manuscript"
    for stem in ("Main-analysis", "Supplement", "TRIPOD-LLM", *[f"Table{i}" for i in range(1, metadata.MAIN_TABLE_COUNT + 1)]):
        sources[f"output/manuscript/{stem}.docx"] = output / f"{stem}.docx"
    for i in range(1, metadata.MAIN_FIGURE_COUNT + 1):
        for suffix in ("pdf", "png"):
            name = f"Figure{i}.{suffix}"
            sources[f"output/manuscript/{name}"] = output / name
    missing = [str(path) for path in sources.values() if not path.is_file()]
    if missing:
        raise SystemExit("Build publication artifacts first:\n" + "\n".join(missing))
    destination.mkdir(parents=True, exist_ok=True)
    previous_manifest = destination / 'publication-manifest.json'
    if previous_manifest.is_file():
        previous_files = json.loads(previous_manifest.read_text(encoding='utf-8'))['files']
        obsolete = [(destination / name).resolve() for name in previous_files.keys() - sources.keys()]
        if any(not path.is_relative_to(destination) for path in obsolete):
            raise SystemExit('Previous publication manifest contains an out-of-package path.')
        for path in obsolete:
            if path.is_file():
                path.unlink()
    manifest = {"source_commit": subprocess.check_output(
        ["git", "-C", str(ROOT), "rev-parse", "HEAD"], text=True).strip(), "files": {}}
    for relative, source in sources.items():
        target = destination / relative
        target.parent.mkdir(parents=True, exist_ok=True)
        if source.suffix == '.html':
            # Git stores text as LF; hash the exact bytes Pages will serve.
            body = source.read_bytes().replace(b'\r\n', b'\n')
            # Older rendered reports gain the same navigation as new Quarto pages.
            if b'id="publication-navigation"' not in body and re.search(br'<body\b[^>]*>', body):
                navigation = (ROOT / 'scripts/publication-nav.html').read_bytes().replace(b'\r\n', b'\n')
                body = re.sub(br'(<body\b[^>]*>)', lambda m: m[1] + b'\n' + navigation, body, count=1)
            target.write_bytes(body)
        else:
            shutil.copyfile(source, target)
        manifest["files"][relative] = {"sha256": hashlib.sha256(target.read_bytes()).hexdigest(),
                                      "bytes": target.stat().st_size}
    (destination / ".nojekyll").touch()
    (destination / "publication-manifest.json").write_text(
        json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    count = check_links(destination)
    print(f"Staged {len(sources)} publication files; {count} local links resolve.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("destination", type=Path)
    parser.add_argument("--check-only", action="store_true")
    args = parser.parse_args()
    if args.check_only:
        print(f"PASS: {check_links(args.destination.resolve())} local links resolve.")
    else:
        stage(args.destination)
