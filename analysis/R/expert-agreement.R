# All new reference analyses were defined by the authors on 2026-10-21.
expert_references <- function(inputs,phase='independent') {
  x <- inputs$adjud |> transmute(slug,domain,adjudicator,reference=.data[[phase]])
  overall <- x |> group_by(slug,adjudicator) |> summarise(reference=derived_overall(reference),.groups='drop') |> mutate(domain='Overall')
  bind_rows(x,overall)
}
reference_predictions <- function(inputs,labels=inputs$labels) {
  bind_rows(labels |> transmute(slug,domain,source=if_else(arm=='ARBITER-Sonnet','ARBITER','Unassisted'),label),
    labels |> filter(arm=='ARBITER-Sonnet') |> transmute(slug,domain,source='Published',label=meta))
}
expert_agreement <- function(inputs,weights,labels=inputs$labels,phase='independent') {
  refs <- expert_references(inputs,phase)
  agreed <- refs |> pivot_wider(names_from=adjudicator,values_from=reference) |> filter(`1`==`2`) |>
    transmute(slug,domain,adjudicator='Agreed reference',reference=`1`)
  refs <- bind_rows(refs,agreed)
  predictions <- reference_predictions(inputs,labels)
  published_overall <- predictions |> filter(source=='Published',domain=='Overall',!is.na(label)) |> pull(slug)
  estimates <- differences <- confusion <- list()
  expert1 <- list()
  for(a in c('1','2','Agreed reference')) for(g in c('D1-D5',paste0('D',1:5),'Overall')) {
    ref <- refs |> filter(adjudicator==a,if(g=='D1-D5') domain!='Overall' else domain==g)
    reps <- metadata <- paired <- pair_metadata <- list()
    populations <- if(g=='Overall') c('All trials','Observed Published Overall') else 'All domain cells'
    for(population in populations) {
      r <- if(population=='Observed Published Overall') filter(ref,slug %in% published_overall) else ref
      sources <- if(g=='Overall' && population=='All trials') c('ARBITER','Unassisted') else c('ARBITER','Unassisted','Published')
      for(s in sources) {
        d <- r |> inner_join(filter(predictions,source==s),by=c('slug','domain')) |> mutate(meta=reference)
        key <- paste(s,population,sep='|')
        reps[[key]] <- agreement_replicates(d,weights)[c('accuracy','kappa'),,drop=FALSE]
        metadata[[key]] <- list(source=s,population=population,n=nrow(d))
        estimates[[length(estimates)+1L]] <- interval_table(reps[[key]]) |>
          mutate(adjudicator=a,source=s,domain=g,population=population,n=nrow(d),
            count=if_else(metric=='accuracy',sum(!is.na(d$label)&d$label==d$reference),NA_integer_))
        # Confusion matrices use full model cohorts and observed Published labels.
        if(g!='D1-D5' && !(g=='Overall' && population=='Observed Published Overall' && s!='Published'))
          confusion[[length(confusion)+1L]] <- d |> mutate(predicted=coalesce(label,'Missing')) |>
            count(domain,reference,predicted) |> mutate(adjudicator=a,source=s)
      }
      pairs <- if(length(sources)==2L) list(c('ARBITER','Unassisted')) else
        list(c('ARBITER','Unassisted'),c('ARBITER','Published'),c('Unassisted','Published'))
      for(pair in pairs) {
        comparison <- paste(pair,collapse=' minus ')
        key <- paste(comparison,population,sep='|')
        paired[[key]] <- reps[[paste(pair[1],population,sep='|')]]-reps[[paste(pair[2],population,sep='|')]]
        pair_metadata[[key]] <- list(comparison=comparison,population=population,n=nrow(r))
        differences[[length(differences)+1L]] <- interval_table(paired[[key]]) |>
          mutate(adjudicator=a,comparison=comparison,domain=g,population=population,n=nrow(r))
      }
    }
    if(a=='1') expert1[[g]] <- list(reps=reps,paired=paired)
    if(a=='2') {
      for(key in names(reps)) {
        m <- metadata[[key]]
        estimates[[length(estimates)+1L]] <- interval_table((expert1[[g]]$reps[[key]]+reps[[key]])/2) |>
          mutate(adjudicator='Mean of experts',source=m$source,domain=g,population=m$population,n=m$n,count=NA_integer_)
      }
      for(key in names(paired)) {
        m <- pair_metadata[[key]]
        differences[[length(differences)+1L]] <- interval_table((expert1[[g]]$paired[[key]]+paired[[key]])/2) |>
          mutate(adjudicator='Mean of experts',comparison=m$comparison,domain=g,population=m$population,n=m$n)
      }
    }
  }
  list(estimates=bind_rows(estimates),differences=bind_rows(differences),confusion=bind_rows(confusion))
}
expert_reliability <- function(inputs,weights) {
  x <- expert_references(inputs) |> pivot_wider(names_from=adjudicator,values_from=reference)
  bind_rows(lapply(c('D1-D5',paste0('D',1:5),'Overall'),function(g) {
    d <- x |> filter(if(g=='D1-D5') domain!='Overall' else domain==g) |> transmute(slug,meta=`1`,label=`2`)
    interval_table(agreement_replicates(d,weights)[c('accuracy','kappa'),,drop=FALSE]) |>
      mutate(domain=g,n=nrow(d),count=if_else(metric=='accuracy',sum(d$meta==d$label),NA_integer_))
  }))
}
validate_derived_overall <- function(inputs) {
  a <- inputs$adjud |> filter(adjudicator=='2')
  calculated <- a |> group_by(slug) |> summarise(across(c(human,kit,nokit,independent,chosen_label,revised),derived_overall),.groups='drop') |>
    pivot_longer(-slug,names_to='column',values_to='calculated')
  map <- c('Human (published)'='human','Kit'='kit','No-kit'='nokit','Independent (derived)'='independent',
    'Chosen label (derived)'='chosen_label','Revised (derived)'='revised')
  sheet <- inputs$overall_sheet |> rename(slug=Trial) |> pivot_longer(-slug,names_to='column',values_to='workbook') |>
    mutate(column=unname(map[column]),workbook=clean_label(workbook))
  stopifnot(!anyNA(sheet$column))
  sheet |> left_join(calculated,by=c('slug','column')) |> mutate(matches=(is.na(workbook)&is.na(calculated))|
    (!is.na(workbook)&!is.na(calculated)&workbook==calculated))
}
direction_of_disagreement <- function(cells,weights) {
  bind_rows(lapply(c('kit','nokit'),function(s) bind_rows(lapply(c('Stricter','More lenient'),function(direction) {
    z <- cells |> filter(!is.na(.data[[s]]),.data[[s]]!=meta,
      (match(.data[[s]],LABELS)>match(meta,LABELS))==(direction=='Stricter'))
    bind_rows(lapply(c('1','2'),function(a) {
      ref <- z[[paste0('independent_',a)]]
      outcome <- ifelse(ref==z[[s]],'Expert matches model',ifelse(ref==z$meta,'Expert matches Published','Expert matches neither'))
      bind_rows(lapply(c('Expert matches model','Expert matches Published','Expert matches neither'),function(o)
        interval_table(share_estimate(z,outcome==o,weights)) |> mutate(source=if(s=='kit') 'ARBITER' else 'Unassisted',
          direction=direction,adjudicator=a,outcome=o,n=nrow(z),count=sum(.env$outcome==.env$o))))
    }))
  }))))
}
primary_analyses <- function(cells,weights) {
  bind_rows(lapply(c('Consensus','Adjudicator 1','Adjudicator 2','Split sensitivity'),function(a) win_share(cells,weights,a)),
    bind_rows(lapply(c('Stricter','More lenient'),function(direction) {
      x <- cells |> filter(consensus,discordant,(match(kit,LABELS)>match(nokit,LABELS))==(direction=='Stricter'))
      win_share(x,weights) |> mutate(analysis=paste('Post hoc:',direction))
    })))
}
forced_choice_summary <- function(cells) {
  d <- cells |> filter(disputed)
  bind_rows(lapply(c('1','2'),function(a) bind_rows(lapply(c('meta','kit','nokit'),function(s)
    tibble(adjudicator=a,source=c(meta='Published',kit='ARBITER',nokit='Unassisted')[[s]],
      n=nrow(d),count=sum(!is.na(d[[s]])&d[[s]]==d[[paste0('chosen_label_',a)]])))))) |>
    mutate(estimate=count/n)
}
revised_rating_summary <- function(inputs) {
  inputs$adjud |> count(adjudicator,independent,revised,name='count') |> group_by(adjudicator) |>
    mutate(n=sum(count),estimate=count/n) |> ungroup()
}
rules_only_analysis <- function(inputs,checks,cells,weights) {
  labels <- rules_only_labels(inputs$labels,checks)
  original <- inputs$labels |> filter(arm=='Baseline-Sonnet',domain!='Overall') |> select(slug,domain,original=label)
  replacements <- labels |> filter(arm=='Baseline-Sonnet',domain!='Overall') |> select(slug,domain,recomputed=label)
  changed <- left_join(original,replacements,by=c('slug','domain')) |> filter(!is.na(original),original!=recomputed) |>
    left_join(cells |> select(slug,domain,discordant,consensus),by=c('slug','domain'))
  # The original discordant population remains fixed even if a rule repair creates a tie.
  recells <- cells |> select(-nokit) |> left_join(replacements |> rename(nokit=recomputed),by=c('slug','domain'))
  list(changed=changed,primary=bind_rows(lapply(c('Consensus','Adjudicator 1','Adjudicator 2','Split sensitivity'),function(a) win_share(recells,weights,a))),
    agreement=expert_agreement(inputs,weights,labels)$estimates)
}
expert_unweighted <- function(inputs,weights) {
  refs <- expert_references(inputs)
  x <- inner_join(refs,reference_predictions(inputs),by=c('slug','domain'),relationship='many-to-many') |>
    filter(!(source=='Published' & domain=='Overall' & is.na(label)))
  observed <- reference_predictions(inputs) |> filter(source=='Published',domain=='Overall',!is.na(label)) |> pull(slug)
  x <- x |> mutate(population=if_else(domain!='Overall','All domain cells',
    if_else(source=='Published','Observed Published Overall','All trials')))
  x <- bind_rows(x,x |> filter(domain=='Overall',source!='Published',slug %in% observed) |>
    mutate(population='Observed Published Overall'))
  bind_rows(lapply(split(x,interaction(x$adjudicator,x$source,x$domain,x$population,drop=TRUE)),function(d) {
    label <- d$label
    label[is.na(label)] <- ifelse(d$reference[is.na(label)]=='Low','High','Low')
    code <- match(d$reference,LABELS)+3*(match(label,LABELS)-1)
    w <- bootstrap_rows(d,weights)
    counts <- sapply(1:9,function(k) as.numeric(crossprod(as.numeric(code==k),w)))
    interval_table(rbind(kappa=unweighted_kappa(counts))) |>
      mutate(adjudicator=d$adjudicator[1],source=d$source[1],domain=d$domain[1],population=d$population[1],n=nrow(d))
  }))
}
