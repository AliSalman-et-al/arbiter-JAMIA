"""Stage the public reports and their downloads, then check every local link."""
from __future__ import annotations

import argparse
import hashlib
from html.parser import HTMLParser
import json
from pathlib import Path
import shutil
import subprocess
from urllib.parse import unquote, urlsplit

ROOT = Path(__file__).resolve().parents[1]


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
    for stem in ("Manuscript", "Supplement", "TRIPOD-LLM", "Table1", "Table2", "Table3"):
        sources[f"output/manuscript/{stem}.docx"] = output / f"{stem}.docx"
    for i in range(1, 6):
        for suffix in ("pdf", "png"):
            name = f"Figure{i}.{suffix}"
            sources[f"output/manuscript/{name}"] = output / name
    for source in sorted(output.glob("eFigure*")):
        if source.suffix.lower() in {".pdf", ".png"}:
            sources[f"output/manuscript/{source.name}"] = source
    missing = [str(path) for path in sources.values() if not path.is_file()]
    if missing:
        raise SystemExit("Build publication artifacts first:\n" + "\n".join(missing))
    destination.mkdir(parents=True, exist_ok=True)
    manifest = {"source_commit": subprocess.check_output(
        ["git", "-C", str(ROOT), "rev-parse", "HEAD"], text=True).strip(), "files": {}}
    for relative, source in sources.items():
        target = destination / relative
        target.parent.mkdir(parents=True, exist_ok=True)
        if source.suffix == '.html':
            # Git stores text as LF; hash the exact bytes Pages will serve.
            target.write_bytes(source.read_bytes().replace(b'\r\n', b'\n'))
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
