results_sentences <- function() {
  a <- read_display('independent-estimates') |> filter(domain=='D1-D5',metric=='accuracy',adjudicator %in% c('1','2'))
  d <- read_display('independent-differences') |> filter(domain=='D1-D5',metric=='accuracy',comparison=='ARBITER minus Unassisted',adjudicator %in% c('1','2'))
  p <- read_display('primary-endpoint') |> filter(analysis=='Consensus',metric=='ARBITER')
  delta <- function(x) paste0(fmt_number(100*x$estimate,1),' ',fmt_ci(100*x$lower,100*x$upper,1))
  expert_text <- vapply(c('1','2'),function(e) {
    x <- filter(a,adjudicator==e); z <- filter(d,adjudicator==e)
    paste0('Expert ',e,': ARBITER ',fmt_fraction(x$count[x$source=='ARBITER'],510),
      ' versus Unassisted ',fmt_fraction(x$count[x$source=='Unassisted'],510),'; paired gain ',delta(z),' percentage points.')
  },character(1))
  out <- c('The benchmark included 102 trials from 16 reviews and 510 domain cells after exclusion of three unsupported designs (Figure 3; Table 1). Both experts independently assessed every cell.',
    'Against Published across all 510 cells, exact agreement is 386/510 (75.7%) for ARBITER versus 395/510 (77.5%) for Unassisted, a paired difference of −1.8 points (95% CI −5.1 to 1.6).',
    paste(paste(expert_text,collapse=' '),'Figure 4 shows absolute levels and paired gains, with the largest observed gains in D5. D3 remains strongly reference-dependent: ARBITER matches 43/102 ratings from Expert 1 and 80/102 from Expert 2. The experts agree on 54/102 D3 cells.'),
    paste0('Conditional blinded-label choices favored ARBITER in ',p$count,'/',p$n,' agreed choices (',fmt_percent(p$estimate,p$n),'%; 95% CI, ',sub('^[(]','',sub('[)]$','',fmt_percent_ci(p$lower,p$upper,p$n))),'%). These 60 agreed choices arose from 80 arm-discordant cells, with 20 split choices. Expert-specific and split-loss sensitivities are in Table 2.'),
    'Figure 5 distinguishes five-level from collapsed signalling-answer agreement on paired eligible components. In D3 against Expert 1, the five-level difference is −10.3 points (95% CI −17.2 to −3.2), whereas the collapsed difference is +8.5 (3.5–13.7), both on 165 components. D5 collapsed gains are +11.3 points for Expert 1 and +3.7 (−0.3 to 7.4) for Expert 2. eTable 4 retains source-specific domain summaries, eligibility accounting and complete paired question contrasts for both codings, including sparse and unfavorable results.',
    'Table 3 reports process conformance and computational resources. All 510 ARBITER domain outputs reproduce from the rule engine; Unassisted has 65/509 evaluable rule breaks (26 contradictory ratings and 39 required-question omissions). In separate structural checks, all 1538 active required answers cite evidence; 1407/1407 text spans and 14 image records are source-bound, and 102 bundles pass structural verification. These checks do not establish semantic support.',
    'Median (IQR) runtime is 7.6 (6.1–10.5) versus 0.5 (0.4–0.5) minutes per trial, with a paired mean difference of 11.0 (95% CI 8.4–14.1) minutes. API list-price equivalents are US$3.78 (3.46–4.10) versus US$0.09 (0.07–0.13), with a paired mean difference of US$3.68 (3.61–3.75). Human time and expenditure were not measured.')
  reader_label(gsub('95% CI ([−0-9])','95% CI, \\1',out))
}
build_results_sentences <- function() writeLines(enc2utf8(paste(results_sentences(),collapse='\n\n')),'output/manuscript/results-sentences.md',useBytes=TRUE)
