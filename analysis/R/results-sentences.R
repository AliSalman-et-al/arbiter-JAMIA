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
  pct <- function(x) fmt_number(100*x,1)
  c(
    sprintf('The benchmark covered %s trials assessed in %s arms, with %s domain disagreements reviewed independently (Figure 3).',nrow(trials),length(unique(manuscript_data('agreement-meta')$arm[manuscript_data('agreement-meta')$arm!='All-Low'])),nrow(flow)),
    sprintf('Both systems agreed poorly with published review labels (weighted κ %s and %s); Published review labels were less severe than the adjudicators’ agreed choice in %s of %s cells (%s%%; Figure 4).',fmt_number(a$estimate[1]),fmt_number(a$estimate[2]),d$n,d$total,pct(d$n/d$total)),
    sprintf('When the two arms disagreed, both adjudicators chose ARBITER’s rating in %s of %s cells (%s%%; 95%% CI %s–%s; Figure 5).',p$count,p$n,pct(p$estimate),pct(p$lower),pct(p$upper)),
    sprintf('The question of whether the analysis plan was fixed in advance alone changed the rating in %s of the unassisted model’s %s eligible ratings not chosen by the adjudicators. Of these, %s had at least one question that alone changed the rating, and %s had none (Figure 6).',f$n,sum(r$eligible),sum(r$with_decisive),sum(r$n)),
    sprintf('Sixteen meta-analyses across %s specialties supplied %s benchmark trials (Table 1).',length(unique(readr::read_csv('data-curated/meta-analyses.csv',show_col_types=FALSE)$specialty)),nrow(trials)),
    sprintf('ARBITER detected %s%% of domain ratings the published reviews labelled Some concerns or High, compared with %s%% for Unassisted (Table 2).',pct(s$estimate[1]),pct(s$estimate[2])),
    sprintf('Without ARBITER, %s of %s evaluable domain ratings broke the RoB 2 rules (%s%%; 95%% CI %s–%s; Table 3).',dep$count,dep$n,pct(dep$estimate),pct(dep$lower),pct(dep$upper)),
    sprintf('Before seeing any label, the adjudicators’ independent ratings agreed with ARBITER in %s and %s of %s domain ratings reviewed (%s%% and %s%%; Table 4).',rel$count[1],rel$count[2],rel$n[1],pct(rel$estimate[1]),pct(rel$estimate[2])),
    sprintf('ARBITER took a median [IQR] of %s minutes per trial versus %s for Unassisted; API list-price equivalents were US$%s versus US$%s. Paired mean differences were %s minutes and US$%s (95%% CIs; eTable %s).',fmt_process_text(process[[2]][1]),fmt_process_text(process[[3]][1]),fmt_process_text(process[[2]][2]),fmt_process_text(process[[3]][2]),fmt_process_text(process[[4]][1]),fmt_process_text(process[[4]][2]),supplement_number('Time, cost and token use per trial by model'))
  )
}
build_results_sentences <- function() writeLines(enc2utf8(paste(results_sentences(),collapse='\n\n')),
  'output/manuscript/results-sentences.md',useBytes=TRUE)
