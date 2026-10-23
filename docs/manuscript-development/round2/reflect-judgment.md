1. **Principle:** Resolve conflicting guidance by identifying the latest accepted decision and its rationale before revising the work.
   **Evidence:** Digest 3: the journal reviewer recommended an older title and abstract; the parent checked the later accepted brief and retained the system-led story.
   **Routing:** `/home/ali/Documents/Code/skills/clinical-research-writing/SKILL.md` — reconciling reviewer recommendations with the accepted manuscript brief.

2. **Principle:** Validate derivative publications against authoritative content, rather than incidental markup or styling conventions.
   **Evidence:** Digest 9–10: stale HTML tables were regenerated from finalized Word tables; a CSS-class assertion was replaced with wrapper checks and exact cell equality.
   **Routing:** new skill: `verify-publication-parity`

3. **Principle:** Verify generated and deployed artifacts only after the producing operation has completed, so transient states are not mistaken for defects.
   **Evidence:** Digest 11: capture during an active refresh reported 13 broken images; capture after completion reported zero. Digest 14: a manifest mismatch disappeared after the queued deployment succeeded.
   **Routing:** new skill: `verify-publication-parity`

4. **Principle:** Preserve reviewer provenance when substituting manual inspection for unavailable independent review; coverage and independence are separate claims.
   **Evidence:** Digest 8: model capacity prevented independent review of pages 1–11, which the parent inspected; another reviewer inspected pages 12–22. The final response summarized all 22 pages as passing review.
   **Routing:** `/home/ali/.codex/plugins/cache/openai-primary-runtime/documents/26.1011.51657/skills/documents/SKILL.md` — proof-review reporting and fallback coverage.

5. **Principle:** Report verification boundaries alongside successful checks, especially when artifact validation succeeds without exercising the full generating pipeline.
   **Evidence:** Digest 15: the final response reported scientific, numerical, and proof verification, while the recorded limitation was that the full R pipeline had not run because dependencies were unavailable.
   **Routing:** `/home/ali/Documents/Code/skills/clinical-research-writing/SKILL.md` — final handoff and reproducibility claims.
