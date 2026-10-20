results_sentences <- function() {
  cells <- read_display('adjudication-analysis-cells')
  p <- read_display('primary-endpoint') |> filter(analysis=='Consensus',metric=='ARBITER')
  a <- read_display('independent-estimates') |> filter(domain=='D1-D5',metric=='accuracy',adjudicator %in% c('1','2'))
  direction <- read_display('direction-of-disagreement') |> filter(source=='ARBITER',direction=='Stricter',outcome=='Expert matches model')
  audit <- read_display('audit-summary') |> filter(arm=='ARBITER (Sonnet 5.5)')
  breaks <- read_display('table3') |> filter(arm=='Unassisted (Sonnet 5.5)',domain=='D1-D5',status=='Any rule break')
  pub <- read_display('table1') |> filter(domain=='D1-D5',metric=='kappa',arm!='All-Low rule')
  process <- read_display('table5')
  rules <- read_display('rules-only-changed')
  signals <- read_display('signalling-estimates') |> filter(group=='Overall',level=='collapsed')
  rel <- read_display('expert-reliability')
  reliability <- rel |> filter(domain=='D1-D5',metric=='accuracy')
  kappa <- rel |> filter(domain=='D1-D5',metric=='kappa')
  d3 <- rel |> filter(domain=='D3',metric=='accuracy')
  differences <- read_display('independent-differences') |> filter(metric=='accuracy',comparison=='ARBITER minus Unassisted',adjudicator %in% c('1','2'))
  overall <- differences |> filter(domain=='Overall',population=='Observed Published Overall')
  signal_diff <- read_display('signalling-differences') |> filter(level=='collapsed')
  signal_all <- signal_diff |> filter(group=='Overall')
  signal_d5 <- signal_diff |> filter(group=='D5')
  signal_d3 <- signal_diff |> filter(group=='D3',adjudicator=='2')
  repaired <- read_display('rules-only-agreement') |> filter(domain=='D1-D5',metric=='accuracy',source=='Unassisted',adjudicator %in% c('1','2'))
  repaired_choice <- read_display('rules-only-primary') |> filter(analysis=='Consensus',metric=='Unassisted')
  original_choice <- read_display('primary-endpoint') |> filter(analysis=='Consensus',metric=='Unassisted')
  pct <- function(v) fmt_number(100*v,1)
  one <- function(who) {
    x <- filter(a,adjudicator==who)
    d <- filter(differences,adjudicator==who,domain=='D1-D5')
    sprintf('Adjudicator %s independently agreed with ARBITER on %s/%s cells (%s%%), Unassisted on %s/%s (%s%%) and Published on %s/%s (%s%%); the paired ARBITER − Unassisted difference was %s percentage points (95%% CI %s–%s; Table 1).',
      who,x$count[1],x$n[1],pct(x$estimate[1]),x$count[2],x$n[2],pct(x$estimate[2]),x$count[3],x$n[3],pct(x$estimate[3]),pct(d$estimate),pct(d$lower),pct(d$upper))
  }
  before <- filter(a,source=='Unassisted')
  quotations <- filter(audit,metric=='Text-span evidence binding')
  c(
    sprintf('All %s trials from %s meta-analyses received two independent expert assessments of all %s domain cells (Figure 3).',n_distinct(cells$slug),n_distinct(cells$meta_id),nrow(cells)),
    sprintf('Among cells where the arms disagreed and the adjudicators made the same forced choice, they preferred ARBITER’s rating in %s/%s (%s%%; 95%% CI %s–%s; Figure 4).',p$count,p$n,pct(p$estimate),pct(p$lower),pct(p$upper)),
    one('1'),one('2'),
    sprintf('On the %s trials with observed Published Overall, the paired ARBITER − Unassisted difference in agreement with derived Overall was %s percentage points (95%% CI %s–%s) for Adjudicator 1 and %s (%s–%s) for Adjudicator 2 (Table 1).',overall$n[1],pct(overall$estimate[1]),pct(overall$lower[1]),pct(overall$upper[1]),pct(overall$estimate[2]),pct(overall$lower[2]),pct(overall$upper[2])),
    sprintf('For ARBITER ratings stricter than Published, the independent expert rating matched ARBITER in %s/%s cells for Adjudicator 1 and %s/%s for Adjudicator 2 (Figure 5B).',direction$count[1],direction$n[1],direction$count[2],direction$n[2]),
    sprintf('Unassisted broke the RoB 2 rules in %s/%s evaluable domain ratings (%s%%; 95%% CI %s–%s), while all %s/%s cited text records were bound to quotations found in content-hashed stored sources (Table 2).',breaks$count,breaks$n,pct(breaks$estimate),pct(breaks$lower),pct(breaks$upper),quotations$count,quotations$n),
    sprintf('Agreement with Published was poor for both arms (weighted κ %s for ARBITER and %s for Unassisted; Table 3).',fmt_number(pub$estimate[1]),fmt_number(pub$estimate[2])),
    sprintf('Median [IQR] system runtime was %s minutes per trial for ARBITER and %s for Unassisted; API list-price equivalents were US$%s and US$%s per trial, respectively (eTable 16).',fmt_process_text(process[[2]][1]),fmt_process_text(process[[3]][1]),fmt_process_text(process[[2]][2]),fmt_process_text(process[[3]][2])),
    sprintf('Rules-only recomputation changed %s Unassisted domain ratings, including %s of the original arm-discordant cells. On the %s cells with an agreed forced choice, Unassisted matched that choice in %s cells before recomputation and %s afterwards. Agreement with the independent ratings fell from %s/%s to %s/%s for Adjudicator 1 and from %s/%s to %s/%s for Adjudicator 2; applying the rule fix did not raise agreement with either expert (eTable 6).',nrow(rules),sum(rules$discordant),repaired_choice$n,original_choice$count,repaired_choice$count,before$count[1],before$n[1],repaired$count[1],repaired$n[1],before$count[2],before$n[2],repaired$count[2],repaired$n[2]),
    sprintf('Across evaluable signalling answers, collapsed agreement was %s%% and %s%% for ARBITER and Unassisted against Adjudicator 1, and %s%% and %s%% against Adjudicator 2. On paired answers, the ARBITER − Unassisted differences were %s percentage points (95%% CI %s–%s) and %s (%s–%s), respectively (Figure 6; eTable 5).',pct(signals$estimate[1]),pct(signals$estimate[2]),pct(signals$estimate[3]),pct(signals$estimate[4]),pct(signal_all$estimate[1]),pct(signal_all$lower[1]),pct(signal_all$upper[1]),pct(signal_all$estimate[2]),pct(signal_all$lower[2]),pct(signal_all$upper[2])),
    sprintf('For Adjudicator 1, the largest collapsed domain gap was in D5: %s percentage points (95%% CI %s–%s). For Adjudicator 2, the D5 gap was %s (95%% CI %s), and the largest gap was in D3 (%s; 95%% CI %s–%s). Question-specific paired differences are shown in Figure 6 and domain-level agreement in eFigure 2.',pct(signal_d5$estimate[1]),pct(signal_d5$lower[1]),pct(signal_d5$upper[1]),pct(signal_d5$estimate[2]),gsub('^\\(|\\)$','',fmt_ci(100*signal_d5$lower[2],100*signal_d5$upper[2],1)),pct(signal_d3$estimate),pct(signal_d3$lower),pct(signal_d3$upper)),
    signalling_disagreement_sentence(),
    sprintf('The experts independently agreed on %s/%s domain ratings (%s%%; weighted κ %s); agreement was lowest in D3 (%s/%s; eTable 8).',reliability$count,reliability$n,pct(reliability$estimate),fmt_number(kappa$estimate),d3$count,d3$n))
}
build_results_sentences <- function() writeLines(enc2utf8(paste(results_sentences(),collapse='\n\n')),'output/manuscript/results-sentences.md',useBytes=TRUE)
