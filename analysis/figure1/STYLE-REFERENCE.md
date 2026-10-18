# Style reference: An Illustrated Guide to AI Agents

Figures 1 and 2 follow the visual grammar of Grootendorst and Alammar, *An Illustrated Guide to AI Agents* (O'Reilly). The reference images are in
`C:\Users\Ali-Salman\Downloads\MISC\Grootendorst, & Alammar, Jay\Illustrated Guide to AI Agents\images\`. Open the cited images before building.

## Principles

1. **One idea per figure.** Each figure follows one path the eye cannot lose. The book does not lay out dense grids of text.
2. **Actors are simple blocks.** The LLM is always a lavender block with blue bold text. Other actors are plain rounded blocks with heavy black outlines. Icons are line glyphs.
3. **Short labels.** Labels are one to three words. Real text appears only where it is the point, as a short payload inside a pill or box.
4. **Colour means role, everywhere.** The same colour always means the same actor or kind of thing.
5. **The output is unmistakable.** In the book, the answer is a filled, bold pill.
6. **Annotations tell the reader what to notice.** They are italic sentences on curved arrows, with keywords bold or coloured to match the element they refer to.

## Devices, with reference images

| Device | Images | Use in ARBITER figures |
|---|---|---|
| Sequence lifelines: two vertical actor bars with horizontal messages; a bold stage title above each message; the real payload in a pill on the message line | 000166 | Figure 2 Panel A: LLM agent lifeline and ARBITER server lifeline |
| Numbered black circle badges (white numerals) beside arrows, each with a verb-led phrase that bolds the key noun ("Send **prompt** to host") | 000191, 000192, 000193, 000097 | Figure 2 Panel A steps ❶–❻ |
| Tool names in monospace pills | 000191, 000192, 000143 | MCP tool names on messages |
| Reasoning box: a soft box beside the LLM, with key words coloured to match what they refer to | 000168, 000170, 000203 | The agent's justification in Panel A |
| Tabbed tag: a dark left tab naming the source, a coloured body holding the content ("db1 \| Context") | 000143 | Evidence tags `[p 4 · L16–35 │ "quote"]` in Panels A and B |
| Highlighter pills linking the same item across boxes, by colour | 000202, 000203, 000037 | Evidence-type colours: direct support yellow, context grey |
| Trajectory rows: agent icon → row of Thought / Tool-call blocks → Output → Outcome ✓/✗ | 000230 | Figure 2 Panel C, ARBITER vs Unassisted |
| Human-preference table with ✓ marks and a person glyph | 000226, 000228 | Panel C Outcome column header (Adjudicators) |
| Dashed grey stage containers with bold numbered titles "(1) Embed" | 000139, 000143, 000098 | Optional grouping of Panel A stages |
| Italic annotation with a curved arrow | 000014, 000171, 000172, 000188 | At most three notes per figure |
| Fading or greying of elements not in focus | 000193, 000143 (db2 and db3 faded) | Not-asked questions; elements outside the traced path |
| Code window (dark box, traffic-light dots) | 000014, 000166 | Avoid; too heavy for a journal figure |

## Type and shape

- **Fonts:**
  - Fira Sans Condensed for diagram text, bold for titles.
  - A monospace face for tool names, handles and hashes.
  - Italic for annotations and quoted model text.
- **Outlines:** heavy black (about 1.2–1.5 pt at final size) on primary blocks; thinner outlines on pills.
- **Corners:** rounded, about 1.5 mm.
- **Arrows:** solid black with a filled triangular head. Curved arrows are smooth Béziers. Every arrowhead tip stops short of its target text.
- **Whitespace:** generous but structured. Elements align to a grid, with no large accidental gaps.

## Colour roles for ARBITER (fixed across Figures 1 and 2)

| Role | Colour |
|---|---|
| LLM agent | lavender fill, blue-violet bold text |
| ARBITER server | mint fill |
| Bundle | pale yellow fill |
| Sources | white document glyphs with a grey hash tag |
| Direct-support evidence | yellow highlighter |
| Context evidence | pale grey highlighter |
| Inference | dashed outline, no fill |
| Not-asked question | diagonal hatching, grey |
| ARBITER arm | blue #00A1D5 |
| Unassisted arm | orange #DF8F44 |
| Published label | slate #374E55 |
| Judgement outputs | filled pill (Low plain white with a heavy outline; Some concerns pale blue) |
| Outcome marks | ✓ green-neutral, ✗ dark red; check greyscale |
