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
  strict <- manuscript_data('vindicated-disagreements') |> distinct(source,direction,all_n) |>
    group_by(source) |> summarise(stricter=sum(all_n[direction=='More severe']),total=sum(all_n),.groups='drop')
  mechanism <- manuscript_data('question51-mechanism')
  rules <- manuscript_data('rules-only-recomputation-changed')
  wins <- manuscript_data('rules-only-recomputation-win_share') |> filter(metric=='Baseline')
  pub <- manuscript_data('rules-only-recomputation-agreement') |> filter(domain=='D1-D5',metric=='accuracy')
  agreed <- manuscript_data('rules-only-recomputation-agreed_choice')
  c(
    sprintf('The benchmark covered %s trials assessed in two arms, with %s domain disagreements reviewed independently (Figure 3).',nrow(trials),nrow(flow)),
    sprintf('Both models agreed poorly with published review labels (weighted κ %s for ARBITER and %s for Unassisted; Table 1; Figure 4A); where they disagreed, they were usually stricter: ARBITER %s/%s and Unassisted %s/%s.',fmt_number(a$estimate[1]),fmt_number(a$estimate[2]),strict$stricter[1],strict$total[1],strict$stricter[2],strict$total[2]),
    sprintf('Adjudicators usually upheld stricter model ratings: %s/%s for ARBITER and %s/%s for Unassisted; for more lenient ratings, the corresponding counts were %s/%s and %s/%s (Figure 4B).',direction$count[1],direction$n[1],direction$count[3],direction$n[3],direction$count[2],direction$n[2],direction$count[4],direction$n[4]),
    sprintf('Among adjudicated cells where the two arms disagreed, both adjudicators preferred ARBITER’s rating in %s of %s cells (%s%%; 95%% CI %s–%s; Figure 5); their independent ratings agreed with ARBITER in %s and %s of %s reviewed ratings (Table 2).',p$count,p$n,pct(p$estimate),pct(p$lower),pct(p$upper),rel$count[1],rel$count[2],rel$n[1]),
    sprintf('Among the %s eligible Unassisted ratings the adjudicators did not choose, %s hinged on at least one question that alone changed the rating; the analysis-plan question (%s) did so in %s (Figure 6). In the post hoc rules-only recomputation, %s of the original 62 arm disagreements changed, each to ARBITER’s rating, which the adjudicators had preferred; the other %s were unchanged (eTable %s).',sum(r$eligible),sum(r$with_decisive),format(f$question,nsmall=1),f$n,sum(rules$consensus & rules$discordant,na.rm=TRUE),62-sum(rules$consensus & rules$discordant,na.rm=TRUE),supplement_number('Post hoc: rules-only changes make three arm disagreements ties')),
    sprintf('In the post hoc description of the %s question 5.1 losses, %s had a supplied registry record, protocol or SAP, but none of the Unassisted justifications mentioned any of these documents (eTable %s).',nrow(mechanism),sum(mechanism$registry_or_protocol_or_sap),supplement_number('Post hoc: supplied documents and answers in question 5.1 losses')),
    sprintf('Without ARBITER, %s of %s evaluable domain ratings broke the RoB 2 rules (%s%%; 95%% CI %s–%s; Table 3); ARBITER had zero domain rule breaks by design and no recorded overrides, and every quotation was found in its content-hashed stored source.',dep$count,dep$n,pct(dep$estimate),pct(dep$lower),pct(dep$upper)),
    sprintf('ARBITER’s system runtime was a median [IQR] of %s minutes per trial versus %s for Unassisted; API list-price equivalents were US$%s versus US$%s. The runs used a subscription. Paired mean differences were %s minutes and US$%s (95%% CIs; eTable %s).',fmt_process_text(process[[2]][1]),fmt_process_text(process[[3]][1]),fmt_process_text(process[[2]][2]),fmt_process_text(process[[3]][2]),fmt_process_text(process[[4]][1]),fmt_process_text(process[[4]][2]),supplement_number('Time, cost and token use per trial by model'))
  )
}
build_results_sentences <- function() writeLines(enc2utf8(paste(results_sentences(),collapse='\n\n')),
  'output/manuscript/results-sentences.md',useBytes=TRUE)
