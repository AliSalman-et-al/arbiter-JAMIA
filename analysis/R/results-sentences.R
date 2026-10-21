results_sentences <- function() {
  cells <- read_display('adjudication-analysis-cells')
  p <- read_display('primary-endpoint') |> filter(analysis=='Consensus',metric=='ARBITER')
  a <- read_display('independent-estimates') |> filter(domain=='D1-D5',metric=='accuracy',adjudicator %in% c('1','2'))
  k <- read_display('independent-estimates') |> filter(domain=='D1-D5',metric=='kappa',adjudicator %in% c('1','2'))
  d <- read_display('independent-differences') |> filter(metric=='accuracy',comparison=='ARBITER minus Unassisted',adjudicator %in% c('1','2'))
  domain <- filter(d,domain=='D1-D5'); overall <- filter(d,domain=='Overall',population=='Observed Published Overall')
  rel <- read_display('expert-reliability'); r <- filter(rel,domain=='D1-D5',metric=='accuracy'); rk <- filter(rel,domain=='D1-D5',metric=='kappa'); d3 <- filter(rel,domain=='D3',metric=='accuracy')
  severity <- read_display('severity-distribution') |> filter(population=='D1-D5',label=='Low')
  direction <- read_display('direction-of-disagreement') |> filter(source=='ARBITER',direction=='Stricter',outcome=='Expert matches model')
  binary <- read_display('independent-binary') |> filter(domain=='D1-D5')
  bd <- read_display('independent-binary-differences') |> filter(domain=='D1-D5')
  pub <- read_display('table1-differences') |> filter(domain=='D1-D5')
  audit <- read_display('audit-summary') |> filter(arm=='ARBITER (Sonnet 5.5)')
  coverage <- filter(audit,metric=='Evidence coverage')
  verifier <- filter(audit,metric=='Bundle verification')
  matched <- read_display('expert-reliability-matched')
  ma <- filter(matched,metric=='accuracy'); mk <- filter(matched,metric=='kappa')
  oa <- read_display('independent-estimates') |> filter(domain=='Overall',population=='Observed Published Overall',metric=='accuracy',source=='ARBITER',adjudicator %in% c('1','2'))
  pub_binary <- read_display('agreement-meta-differences') |> filter(domain=='D1-D5',comparison=='ARBITER (Sonnet 5.5) minus Unassisted (Sonnet 5.5)')
  published_matches <- read_display('direction-of-disagreement') |> filter(source=='ARBITER',direction=='Stricter',outcome=='Expert matches Published')
  quotations <- filter(audit,metric=='Text-span evidence binding')
  breaks <- read_display('table3') |> filter(arm=='Unassisted (Sonnet 5.5)',domain=='D1-D5',status=='Any rule break')
  process <- read_display('table5')
  rules <- read_display('rules-only-changed')
  repaired <- read_display('rules-only-agreement') |> filter(domain=='D1-D5',metric=='accuracy',source=='Unassisted',adjudicator %in% c('1','2'))
  before <- filter(a,source=='Unassisted')
  pc <- read_display('rules-only-primary') |> filter(analysis=='Consensus',metric=='Unassisted')
  oc <- read_display('primary-endpoint') |> filter(analysis=='Consensus',metric=='Unassisted')
  signals <- read_display('signalling-differences') |> filter(group=='Overall',level=='collapsed')
  pct <- function(v) fmt_number(100*v,1)
  delta <- function(x) paste0(pct(x$estimate),' ',fmt_ci(100*x$lower,100*x$upper,1))
  et <- function(title) paste('eTable',supplement_number(title))
  bs <- function(who) {
    x <- filter(binary,adjudicator==who,source %in% c('ARBITER','Unassisted'),metric=='sensitivity')
    dif <- filter(bd,adjudicator==who)
    paste0('Against Expert ',who,', sensitivity was ',paste(pct(x$estimate),collapse='% versus '),
      '% for ARBITER versus Unassisted; paired sensitivity and specificity differences were ',
      delta(filter(dif,metric=='sensitivity')),' and ',delta(filter(dif,metric=='specificity')),' percentage points, respectively')
  }
  specificity <- function(who) {
    x <- filter(binary,adjudicator==who,source %in% c('ARBITER','Unassisted'),metric=='specificity')
    paste0(paste(pct(x$estimate),collapse='% versus '),'% against Expert ',who)
  }
  one <- function(who) {
    x <- filter(a,adjudicator==who)
    paste0('Expert ',who,' agreed with ARBITER in ',x$count[1],'/',x$n[1],' cells (',pct(x$estimate[1]),'%), Unassisted in ',x$count[2],'/',x$n[2],
      ' (',pct(x$estimate[2]),'%) and Published in ',x$count[3],'/',x$n[3],' (',pct(x$estimate[3]),'%).')
  }
  c(
    paste0('Exploratory severity distributions showed that both experts rated Low less often than any other source: ',
      paste0(severity$source,' ',severity$count,'/',severity$n,' (',pct(severity$estimate),'%)',collapse='; '),
      '. Both experts assessed the complete benchmark independently: ',n_distinct(cells$slug),' trials from ',n_distinct(cells$meta_id),' meta-analyses and ',
      (read_display('benchmark-characteristics') |> filter(characteristic=='Specialties') |> pull(count)),' specialties contributed ',nrow(cells),' domain cells (Figure 3; Table 1; ',et('Benchmark trials'),'). ',
      'The experts agreed on ',r$count,'/',r$n,' domain ratings (',pct(r$estimate),'%; weighted κ ',fmt_number(rk$estimate),
      '), with the lowest agreement in D3 (',d3$count,'/',d3$n,'; ',et('Expert reliability'),').'),
    paste0('The prespecified forced-choice endpoint favoured ARBITER: the experts’ agreed choice matched its rating in ',p$count,'/',p$n,' cells (',pct(p$estimate),
      '%; 95% CI ',gsub('^[(]|[)]$','',fmt_ci(100*p$lower,100*p$upper,1)),') where the arms disagreed (Figure 4; ',et('Primary endpoint sensitivities and post hoc strata'),').'),
    paste0('Prespecified independent-rating comparisons favoured ARBITER against both experts. ',one('1'),' ',one('2'),
      ' The paired ARBITER − Unassisted differences (95% CIs) were ',delta(domain[1,]),' and ',delta(domain[2,]),' percentage points, respectively. ',
      'ARBITER’s weighted κ values (',paste(fmt_number(k$estimate[k$source=='ARBITER']),collapse=', '),') fell either side of expert-to-expert κ ',fmt_number(rk$estimate),
      '. Unassisted (',paste(fmt_number(k$estimate[k$source=='Unassisted']),collapse=', '),
      ') and Published (',paste(fmt_number(k$estimate[k$source=='Published']),collapse=', '),') fell below that yardstick. ',
      'Derived Overall comparisons on the ',overall$n[1],' trials with a published Overall gave paired differences of ',delta(overall[1,]),' and ',delta(overall[2,]),
      ' percentage points. Absolute Overall agreement was lower for every source; the experts agreed with each other on ',ma$count,'/',ma$n,' matched Overall ratings (κ ',fmt_number(mk$estimate),'), and ARBITER’s matched Overall agreement was ',oa$count[1],'/',oa$n[1],' against Expert 1 and ',oa$count[2],'/',oa$n[2],' against Expert 2 (Table 2; Figure 5A; eTables ',supplement_number('Full independent agreement and paired contrasts'),'–',supplement_number('Agreed reference and paired contrasts'),'; eFigure 1).'),
    paste0('Exploratory analyses showed that ARBITER’s higher sensitivity for Some concerns or High against each expert came without lower specificity. Specificity was ',
      specificity('1'),' and ',specificity('2'),' for ARBITER versus Unassisted. ',bs('1'),'. ',bs('2'),
      ' (95% CIs; eTables ',supplement_number('Exploratory binary agreement against each expert'),'–',supplement_number('Direction of disagreement against independent experts'),
      '). When ARBITER was stricter than Published, Expert 1 matched ARBITER in ',direction$count[1],'/',direction$n[1],' cells and Published in ',published_matches$count[1],'/',published_matches$n[1],
      '; Expert 2 matched ARBITER in ',direction$count[2],'/',direction$n[2],' and Published in ',published_matches$count[2],'/',published_matches$n[2],' (Figure 5B).'),
    paste0('The prespecified published-label benchmark showed no clear difference between the arms in exact agreement or κ. The paired exact-agreement difference was ',
      delta(filter(pub,metric=='accuracy')),' percentage points and the weighted κ difference ',
      {z <- filter(pub,metric=='kappa');paste0(fmt_number(z$estimate),' ',fmt_ci(z$lower,z$upper))},
      ' (95% CIs; Table 2; Figure 5A; eTables ',supplement_number('Published label agreement'),'–',supplement_number('Unweighted agreement with published labels'),'). Against published labels, ARBITER’s higher sensitivity came with lower specificity: paired differences were +',delta(filter(pub_binary,metric=='sensitivity')),' and ',delta(filter(pub_binary,metric=='specificity')),' percentage points, respectively (95% CIs); against the experts it did not.'),
    paste0('Prespecified signalling-answer comparisons favoured ARBITER. Rules-only recomputation did not raise Unassisted’s agreement. Paired collapsed signalling differences were ',
      delta(signals[1,]),' and ',delta(signals[2,]),' percentage points against Experts 1 and 2, respectively (Figure 6; ',et('Full signalling question agreement'),'; eFigure 2). ',
      'Recomputation changed ',nrow(rules),' Unassisted domain ratings, including ',sum(rules$discordant),' original arm disagreements. Among ',pc$n,' agreed forced choices, Unassisted matched ',oc$count,' before and ',pc$count,' after recomputation. ',
      'Its independent-rating agreement changed from ',before$count[1],'/',before$n[1],' to ',repaired$count[1],'/',repaired$n[1],' against Expert 1 and from ',before$count[2],'/',before$n[2],' to ',repaired$count[2],'/',repaired$n[2],' against Expert 2 (',et('Rules only recomputation'),').'),
    paste0('The prespecified process audit found rule breaks in Unassisted ratings, while ARBITER enforced the rules. Unassisted had ',breaks$count,'/',breaks$n,' evaluable domain ratings with a rule break (',pct(breaks$estimate),
      '%; 95% CI ',gsub('^[(]|[)]$','',fmt_ci(100*breaks$lower,100*breaks$upper,1)),'). ARBITER had zero domain rule breaks by design and no recorded domain overrides; all ',coverage$count,' required answers cited evidence, ',quotations$count,'/',quotations$n,
      ' quotations were found in the stored source, and all ',verifier$count,' audit files passed the independent verifier (Table 3; eTables ',supplement_number('Rule consistency and audit'),'–',supplement_number('Evidence binding'),').'),
    paste0('The prespecified time and cost analyses showed greater resource use for ARBITER. Median [IQR] runtime was ',fmt_process_text(process[[2]][1]),' minutes per trial for ARBITER and ',fmt_process_text(process[[3]][1]),
      ' for Unassisted, with a paired mean difference of ',fmt_process_text(process[[4]][1]),' minutes. API list-price equivalents were US$',fmt_process_text(process[[2]][2]),' and US$',fmt_process_text(process[[3]][2]),
      ' per trial, respectively, with a paired mean difference of US$',fmt_process_text(process[[4]][2]),' (95% CIs; Table 3; ',et('Time cost and token use'),').'))
}
build_results_sentences <- function() writeLines(enc2utf8(paste(results_sentences(),collapse='\n\n')),'output/manuscript/results-sentences.md',useBytes=TRUE)
