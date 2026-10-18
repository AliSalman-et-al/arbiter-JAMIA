build_figure_legends <- function() {
  legends <- c(
    '# Figure legends',
    '',
    '## Figure 1. How ARBITER works',
    '',
    'A, The reviewer, LLM agent, deterministic ARBITER server (no model calls), and exported bundle are shown across four phases: Capture; Propose and approve; Assess each domain; Review and export. Tool calls connect the agent to the server, and the reviewer approves the result. B, A worked answer trace from AVATAR D5 links a captured passage to a signalling answer, the domain answer set, the proposed judgement, source/page/line/hash binding, and bundle verification. The trial judgement strip shows Low in D1-D4 and Some concerns in D5 and Overall. Published and Unassisted judgements are Low; the adjudicators prefer Some concerns. Text spans are server-extracted. Visual regions are server-rendered and hash-bound; model-written transcriptions are not machine-checked against the image. Structural verification does not establish clinical correctness.',
    '',
    'Alt text: Two panels show the reviewer-agent-server-bundle workflow and an AVATAR D5 evidence-to-judgement trace. A highlighted passage reappears beside its signalling answer, with source binding and verification details. The proposed Some concerns judgement differs from the Published and Unassisted Low judgements and matches the adjudicators.',
    '',
    '## Figure 2. Benchmark inclusion and adjudication flow',
    '',
    'Sixteen meta-analyses supplied 105 trials. Three unsupported-design trials were excluded from every arm and analysis, leaving 102 trials, 510 D1-D5 cells per arm and 81 trials with a Published Overall label. Of 154 disputed cells, 129 had consensus and 25 were split. The Sonnet arms differed on 62 consensus cells: 54 ARBITER wins, 7 Unassisted wins and 1 neither. Eighteen split cells also had differing arm judgements.',
    '',
    'Alt text: Flow diagram from 105 trials to 102 included after three exclusions, then 154 disputed cells divided into 129 consensus and 25 split cells. The 62 differing consensus cells yield 54 ARBITER, 7 Unassisted and 1 neither win.',
    '',
    '## Figure 3. Blinded adjudicators prefer ARBITER on discordant judgements',
    '',
    'A, Win shares on cells where the Sonnet arms differ, with 95% percentile bootstrap confidence intervals from 10,000 trial-cluster resamples stratified by meta-analysis (seed 20261018). Rows show both adjudicators in consensus, Adjudicator 1, Adjudicator 2, and a sensitivity counting split discordant cells against ARBITER. Consensus counts are 54/62 ARBITER, 7/62 Unassisted and 1/62 neither; per-adjudicator counts are 60/80, 16/80 and 4/80 for Adjudicator 1 and 64/80, 15/80 and 1/80 for Adjudicator 2. The split sensitivity has 54/80 ARBITER wins, 7/80 Unassisted wins and 19/80 residual cells, including 18 forced ARBITER losses. B, All 154 disputed cells by departure from Published and preferred-label outcome. Shared preferred labels count as Both arms; split adjudicators are separate. Counts are based on label equality, not blinded reviewer letters.',
    '',
    'Alt text: Point estimates and intervals show higher ARBITER than Unassisted win shares in all four analyses. A count matrix shows that the adjudicators preferred ARBITER alone on 54 disputed cells, Unassisted alone on 7, both arms on 62, and Published alone on 6; 25 cells were split.',
    '',
    '## Figure 4. Published labels are a weak reference',
    '',
    'A, Linearly weighted Cohen\u2019s kappa against Published, by domain and pooled D1-D5, for ARBITER and Unassisted with 95% stratified trial-cluster bootstrap confidence intervals. The dashed line marks zero agreement beyond chance; it is not a reported All-Low rule kappa. B, Direction of Published relative to the consensus preferred judgement on 129 consensus disputed cells: less severe, 78/129 (60.5%); equal, 29/129 (22.5%); more severe, 22/129 (17.1%). This selected disputed set cannot estimate published-label accuracy in the full benchmark. The composite reference is reported in Table 2.',
    '',
    'Alt text: The two sources have overlapping domain-level kappa intervals against Published. On consensus disputed cells, Published is less severe than preferred in 78 cells, equal in 29 and more severe in 22.',
    '',
    '## Figure 5. Individually decisive signalling questions behind consensus losses',
    '',
    'Paired ARBITER and Unassisted bars count individually decisive questions among consensus losses for which both adjudicators\u2019 independent judgements equal the preferred judgement (10 ARBITER and 47 Unassisted losses). Domain facets give each source\u2019s eligible loss count; question numbers and abbreviated RoB 2 text identify rows. A question is decisive when substituting the unanimously agreed independent answer alone changes the official algorithm output. A cell can contribute several questions. Jointly decisive sets contribute no individual-question counts; questions with zero counts in both sources are omitted only from this figure. D2 uses effect of assignment.',
    '',
    'Alt text: Domain facets compare decisive-question counts with paired bars. Question 5.1, whether the analysis plan was finalised before unblinding, contributes 18 Unassisted and 2 ARBITER counts. Question 2.3 contributes 3 for each source. Other displayed questions have counts from zero to three.'
  )
  for(path in c('output/manuscript/figure-legends.md','output/figure-legends.md'))
    writeLines(enc2utf8(legends),path,useBytes=TRUE)
}
