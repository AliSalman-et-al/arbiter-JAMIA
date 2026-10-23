1. Principle: A substitute verification path can establish the artifact’s integrity without establishing that the omitted production path still works; report those as separate claims.
   Evidence: The full R pipeline was not run because dependencies were unavailable, while Python/Quarto checks passed and the final response described scientific and numerical verification. The transcript does not show an equivalent run of the R pipeline.
   Routing: `/home/ali/.codex/plugins/cache/openai-primary-runtime/documents/26.1011.51657/skills/documents/SKILL.md`

2. Principle: When independent review fails for capacity reasons, a self-check can reduce risk but should not inherit the status of an independent pass.
   Evidence: The Sol reviewer failed on pages 1–11 with “Selected model is at capacity”; the parent viewed those pages, a separate Sol reviewed pages 12–22, and the final response said all 22 pages passed review. It did not distinguish the parent’s inspection from the independent review.
   Routing: `/home/ali/.codex/plugins/cache/openai-primary-runtime/documents/26.1011.51657/skills/documents/SKILL.md`

3. Principle: A failed live check during an active build is evidence about timing as much as content; rerunning after the build settles is what makes the failure actionable.
   Evidence: The first browser capture overlapped the Quarto refresh and found 13 broken supplement images; after the refresh completed, the repeat capture found zero. The parent correctly reran the check, avoiding a likely false repair.
   Routing: `/home/ali/.codex/plugins/cache/openai-primary-runtime/documents/26.1011.51657/skills/documents/SKILL.md`

4. Principle: Deployment success is not the same as release verification; the strongest evidence came from comparing the deployed files to the exact source revision after the hosted run completed.
   Evidence: The first live verifier found a manifest mismatch while the GitHub run was queued; the parent waited for the run to succeed and then verified all 50 deployed files byte-for-byte against the source commit. The final check resolved a timing ambiguity rather than treating the initial mismatch as a content defect.
   Routing: `/home/ali/.codex/plugins/cache/openai-primary-runtime/documents/26.1011.51657/skills/documents/SKILL.md`
