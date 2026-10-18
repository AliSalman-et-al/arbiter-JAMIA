# Figure 1 deviations and scope decisions

- **Python/uv:** explicitly permitted for this task. A small isolated, locked environment supports programmatic SVG, font outlining and export. It avoids adding diagram-specific font/vector dependencies to the manuscript's R environment. `pyproject.toml` and `uv.lock` are local to Figure 1; no renv or Quarto files changed.
- **PDF converter:** resvg is used for the independent SVG PNG preview. Because resvg outputs raster images, the outlined SVG is converted to vector PDF using svglib/ReportLab; that PDF is rendered with PyMuPDF for the required 600-dpi LZW TIFF. This maintains vector PDF typography without relying on a system Cairo installation. Output has been visually cross-checked between both renderers.
- **Editable typography:** all deliverable SVG/PDF text is outlined as permitted in the brief. The programmatic scene, bundled OFL fonts and accessible SVG labels remain editable; no system font installation is required.
- **Bundle contents:** the bundle lane says source identities, bound evidence and assessment history. The inspected ZIP contains source metadata and server-extracted spans, not captured trial PDF files. The server captures sources in its workspace; the drawing does not imply the PDFs are redistributed in the ZIP.
- **Evidence semantics:** the selected 5.1 citation is recorded as context. The figure makes that visible and explains the missing prospective dating, avoiding a claim that one passage directly proves absence of a plan. AVATAR remains suitable; no fallback was used.
- **Ownership:** the draft legend is in the assigned `figure1-notes.md`. Integration into `analysis/output/figure-legends.md` and the manuscript build is left to the lead because those files are outside this agent's ownership.
- **Verification scope:** manifest file hashes and canonical/CSV consistency are checked during every build. The figure reports the archived independent-verifier result, not a newly executed ARBITER verifier. The CVD proof is approximate and explicitly labelled; grayscale supplies the stronger information-preservation check.

## Round 8b-2

- Public names are checked against the local ARBITER CLI entry point and finalization source; the input archive is read under its original filename. The SVG guard forbids the pre-rename identifier in all SVG content, including accessible labels.
- Four paired request/response arrows show traffic direction; italic response labels summarize server results rather than quoting exact payloads. Monospace tool names use 92% horizontal width, preserving their point height and equal character spacing, to clear the arrows.
- Panel B keeps the recorded 5.1 No information decision. Its two-line reasoning is a summary of the full recorded justification reproduced in the notes. The cited passage remains context; yellow links only source text and its reference in the reasoning.
- Round 8b was cherry-picked because the requested fast-forward was impossible. Work continued on the existing branch. Only the assigned Figure 1 paths were modified.
