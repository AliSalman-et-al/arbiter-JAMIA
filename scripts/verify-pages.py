"""Verify deployed Pages bytes against a locally staged publication manifest."""
from __future__ import annotations

import argparse
from concurrent.futures import ThreadPoolExecutor
import hashlib
import json
from pathlib import Path
from urllib.parse import urljoin
from urllib.request import Request, urlopen


def fetch(url):
    request = Request(url, headers={"User-Agent": "ARBITER-publication-verifier",
                                    "Cache-Control": "no-cache"})
    with urlopen(request, timeout=45) as response:
        if response.status != 200:
            raise RuntimeError(f"HTTP {response.status}: {url}")
        return response.read()


def verify(base, expected):
    base = base.rstrip("/") + "/"
    stamp = expected["source_commit"]
    remote = json.loads(fetch(urljoin(base, "publication-manifest.json") + f"?v={stamp}"))
    if remote != expected:
        raise RuntimeError("Published manifest differs from the staged release.")

    def check(item):
        relative, record = item
        body = fetch(urljoin(base, relative) + f"?v={stamp}")
        digest = hashlib.sha256(body).hexdigest()
        if digest != record["sha256"] or len(body) != record["bytes"]:
            raise RuntimeError(f"Published file differs from staged release: {relative}")
        return {"file": relative, "bytes": len(body), "sha256": digest, "status": "PASS"}

    with ThreadPoolExecutor(max_workers=4) as pool:
        files = list(pool.map(check, expected["files"].items()))
    return {"status": "PASS", "url": base, "source_commit": stamp,
            "verified_files": len(files), "files": files}


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("url")
    parser.add_argument("manifest", type=Path)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    result = verify(args.url, json.loads(args.manifest.read_text(encoding="utf-8")))
    if args.output:
        args.output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(f"PASS: {result['verified_files']} deployed files match source {result['source_commit']}.")
