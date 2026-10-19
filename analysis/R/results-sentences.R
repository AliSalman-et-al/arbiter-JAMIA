# Generated prose reads frozen analysis CSVs rather than hand-entered estimates.
results_sentences <- function() {
  p <- manuscript_data('primary-endpoint') |> filter(analysis=='Consensus',metric=='ARBITER')
  d <- manuscript_data('published-direction-domain') |> filter(domain=='All',direction=='Less severe')
  f <- manuscript_data('error-localisation-frequency') |> filter(population=='Primary',source=='Baseline-Sonnet',question==5.1)
  r <- manuscript_data('no-decisive-counts') |> filter(source=='Baseline-Sonnet')
  a <- manuscript_data('agreement-meta') |> filter(domain=='D1-D5',metric=='kappa',arm %in% c('ARBITER-Sonnet','Baseline-Sonnet'))
  s <- manuscript_data('table2') |> filter(domain=='D1-D5',metric=='sensitivity',arm %in% c('ARBITER-Sonnet','Baseline-Sonnet'))
  dep <- manuscript_data('table3') |> filter(arm=='Baseline-Sonnet',domain=='D1-D5',status=='Departure')
  rel <- manuscript_data('table4-reliability') |> filter(metric=='accuracy',grepl('independent vs ARBITER',comparison))
  flow <- manuscript_data('adjudication-analysis-cells')
  trials <- load_inputs()$trials
  process <- manuscript_data('table5')
  number_words <- function(n) c('one','two','three','four','five','six','seven','eight','nine')[n]
  pct <- function(x) fmt_number(100*x,1)
  direction <- manuscript_data('direction-of-disagreement')
  rules <- manuscript_data('rules-only-recomputation-changed')
  wins <- manuscript_data('rules-only-recomputation-win_share') |> filter(metric=='Baseline')
  pub <- manuscript_data('rules-only-recomputation-agreement') |> filter(domain=='D1-D5',metric=='accuracy')
  agreed <- manuscript_data('rules-only-recomputation-agreed_choice')
  c(
    sprintf('The benchmark covered %s trials assessed in two arms, with %s domain disagreements reviewed independently (Figure 3).',nrow(trials),nrow(flow)),
    sprintf('Both models agreed poorly with published review labels (weighted κ %s for ARBITER and %s for Unassisted; Table 1; Figure 4A).',fmt_number(a$estimate[1]),fmt_number(a$estimate[2])),
    sprintf('Adjudicators usually upheld stricter model ratings in the post hoc analysis: %s/%s for ARBITER and %s/%s for Unassisted; for more lenient ratings, the corresponding counts were %s/%s and %s/%s (Figure 4B).',direction$count[1],direction$n[1],direction$count[3],direction$n[3],direction$count[2],direction$n[2],direction$count[4],direction$n[4]),
    sprintf('When the two arms disagreed, both adjudicators chose ARBITER’s rating in %s of %s cells (%s%%; 95%% CI %s–%s; Figure 5); their independent ratings agreed with ARBITER in %s and %s of %s reviewed ratings (Table 2).',p$count,p$n,pct(p$estimate),pct(p$lower),pct(p$upper),rel$count[1],rel$count[2],rel$n[1]),
    sprintf('Among the %s eligible Unassisted ratings the adjudicators did not choose, %s hinged on at least one question that alone changed the rating; the analysis-plan question (%s) did so in %s (Figure 6). In the post hoc rules-only recomputation, %s of the original 62 arm disagreements changed: Unassisted wins changed from %s to %s, published-label agreement from %s to %s of 510, and agreement with the adjudicators’ agreed choice from %s to %s of 129 (eTable %s).',sum(r$eligible),sum(r$with_decisive),format(f$question,nsmall=1),f$n,sum(rules$consensus & rules$discordant,na.rm=TRUE),wins$count[1],wins$count[2],pub$count[1],pub$count[2],agreed$count[1],agreed$count[2],supplement_number('Post hoc: recomputing Unassisted ratings changes few arm disagreements')),
    sprintf('Without ARBITER, %s of %s evaluable domain ratings broke the RoB 2 rules (%s%%; 95%% CI %s–%s; Table 3); ARBITER had no domain rule breaks or overrides, and every quoted text record was linked to its stored source.',dep$count,dep$n,pct(dep$estimate),pct(dep$lower),pct(dep$upper)),
    sprintf('ARBITER took a median [IQR] of %s minutes per trial versus %s for Unassisted; API list-price equivalents were US$%s versus US$%s. Paired mean differences were %s minutes and US$%s (95%% CIs; eTable %s).',fmt_process_text(process[[2]][1]),fmt_process_text(process[[3]][1]),fmt_process_text(process[[2]][2]),fmt_process_text(process[[3]][2]),fmt_process_text(process[[4]][1]),fmt_process_text(process[[4]][2]),supplement_number('Time, cost and token use per trial by model'))
  )
}
build_results_sentences <- function() writeLines(enc2utf8(paste(results_sentences(),collapse='\n\n')),
  'output/manuscript/results-sentences.md',useBytes=TRUE)
