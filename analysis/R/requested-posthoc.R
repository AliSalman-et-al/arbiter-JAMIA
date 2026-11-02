# R-02 to R-05. Frozen ratings only; original bootstrap and ordinal conventions.
posthoc_ratings <- function(inputs) {
  bind_rows(
    inputs$labels |> transmute(slug,domain,source=if_else(arm=='ARBITER-Sonnet','ARBITER','Direct prompting'),label),
    inputs$labels |> filter(arm=='ARBITER-Sonnet') |> transmute(slug,domain,source='Published labels',label=meta),
    inputs$adjud |> transmute(slug,domain,source=paste('Human Review',adjudicator),label=independent))
}

posthoc_agreement <- function(d,weights,cache) {
  d <- filter(d,!is.na(meta))
  if(!nrow(d)) return(matrix(NA_real_,4,ncol(weights)+1L,
    dimnames=list(c('accuracy','kappa','AC1','AC2'),NULL)))
  old <- agreement_replicates(d,weights)
  # Exactly the missing-prediction convention in agreement_replicates().
  label <- d$label
  missing <- is.na(label)
  label[missing] <- ifelse(d$meta[missing]=='Low','High','Low')
  code <- match(d$meta,LABELS)+3L*(match(label,LABELS)-1L)
  w <- bootstrap_rows(d,weights)
  counts <- vapply(1:9,function(k) as.numeric(crossprod(as.numeric(code==k),w)),numeric(ncol(w)))
  # Use the established implementation for every point and bootstrap coefficient.
  # Memoize identical contingency tables; do not use package analytic CIs/P values.
  keys <- apply(counts,1,paste,collapse=',')
  unique_keys <- unique(keys)
  for(key in unique_keys) if(!exists(key,cache,inherits=FALSE)) {
    tab <- matrix(as.numeric(strsplit(key,',',fixed=TRUE)[[1]]),3,3)
    value <- vapply(list(diag(3),irrCAC::linear.weights(1:3)),function(wt)
      irrCAC::gwet.ac1.table(tab,weights=wt)$coeff.val,numeric(1))
    value[!is.finite(value)] <- NA_real_
    assign(key,value,cache)
  }
  ac <- vapply(keys,function(key) get(key,cache,inherits=FALSE),numeric(2))
  stopifnot(isTRUE(all.equal(unname(old['AC2',]),unname(ac[2,]),tolerance=1e-12)))
  rbind(old[c('accuracy','kappa'),,drop=FALSE],AC1=ac[1,],AC2=ac[2,])
}

run_requested_posthoc <- function(inputs,weights) {
  stopifnot(requireNamespace('irrCAC',quietly=TRUE))
  ratings <- posthoc_ratings(inputs)
  cache <- new.env(hash=TRUE,parent=emptyenv())
  groups <- c('D1-D5',paste0('D',1:5),'Overall')
  refs <- c('Human Review 1','Human Review 2','Published labels')
  arms <- c('ARBITER','Direct prompting','All-Low')
  results <- relative <- availability <- list()
  all_reps <- list()
  for(g in groups) {
    message('Post hoc group: ',g)
    base <- if(g=='D1-D5') filter(ratings,domain!='Overall') else filter(ratings,domain==g)
    frame <- tidyr::crossing(slug=inputs$trials$slug,domain=if(g=='D1-D5') paste0('D',1:5) else g)
    for(ref in refs) {
      r <- frame |> left_join(filter(base,source==ref) |> select(slug,domain,meta=label),by=c('slug','domain'))
      reps <- list()
      for(a in arms) {
        d <- if(a=='All-Low') mutate(r,label='Low') else left_join(r,
          filter(base,source==a) |> select(slug,domain,label),by=c('slug','domain'))
        reps[[a]] <- posthoc_agreement(d,weights,cache)
        results[[length(results)+1L]] <- interval_table(reps[[a]]) |> mutate(domain=g,reference=ref,source=a,
          n=sum(!is.na(d$meta)),excluded_reference=sum(is.na(d$meta)),
          missing_prediction=sum(!is.na(d$meta)&is.na(d$label)),
          count=if_else(metric=='accuracy',sum(!is.na(d$meta)&!is.na(d$label)&d$meta==d$label),NA_integer_))
      }
      results[[length(results)+1L]] <- interval_table(reps$ARBITER-reps[['Direct prompting']]) |>
        mutate(domain=g,reference=ref,source='ARBITER minus Direct prompting',n=sum(!is.na(r$meta)),
          excluded_reference=sum(is.na(r$meta)),missing_prediction=NA_integer_,count=NA_integer_)
      all_reps[[paste(g,ref)]] <- reps
      message('  Completed ',ref)
    }
    h <- frame |> left_join(filter(base,source=='Human Review 1') |> select(slug,domain,meta=label),by=c('slug','domain')) |>
      left_join(filter(base,source=='Human Review 2') |> select(slug,domain,label),by=c('slug','domain'))
    h <- filter(h,!is.na(meta),!is.na(label))
    hh <- posthoc_agreement(h,weights,cache)
    results[[length(results)+1L]] <- interval_table(hh) |> mutate(domain=g,reference='Human Review 2',source='Human Review 1',
      n=nrow(h),excluded_reference=nrow(frame)-nrow(h),missing_prediction=0L,
      count=if_else(metric=='accuracy',sum(h$meta==h$label),NA_integer_))
    if(g!='Overall') {
      ds <- lapply(arms[1:2],function(a) (all_reps[[paste(g,refs[1])]][[a]]+
        all_reps[[paste(g,refs[2])]][[a]])/2-hh)
      for(i in 1:3) relative[[length(relative)+1L]] <- interval_table(
        (if(i==3) ds[[1]]-ds[[2]] else ds[[i]])[c('accuracy','kappa'),,drop=FALSE]) |>
        mutate(domain=g,source=c(arms[1:2],'ARBITER minus Direct prompting')[i],n=510L/ifelse(g=='D1-D5',1L,5L))
    }
  }
  estimates <- bind_rows(results) |> mutate(analysis='post hoc')
  relative <- bind_rows(relative) |> mutate(analysis='post hoc')
  distribution <- bind_rows(lapply(groups,function(g) {
    frame <- tidyr::crossing(slug=inputs$trials$slug,domain=if(g=='D1-D5') paste0('D',1:5) else g,
      source=c('ARBITER','Direct prompting',refs)) |>
      left_join(ratings,by=c('slug','domain','source')) |> mutate(label=coalesce(label,'Missing'))
    frame |> count(source,label,name='count') |>
      complete(source,label=c(LABELS,'Missing'),fill=list(count=0L)) |>
      group_by(source) |> mutate(n=sum(count),percent=100*count/n) |> ungroup() |> mutate(domain=g,analysis='post hoc')
  }))
  availability <- distribution |> filter(domain=='Overall') |> group_by(source) |>
    summarise(recorded=sum(count[label!='Missing']),missing=sum(count[label=='Missing']),total=102L,.groups='drop') |>
    mutate(provenance=if_else(grepl('Human Review',source),'No independently recorded Overall; domain-derived Overall is a separate existing diagnostic','Recorded Overall'),analysis='post hoc')
  save <- function(x,name) readr::write_csv(x,paste0('output/tables/posthoc-',name,'.csv'),na='')
  save(filter(estimates,domain!='Overall'),'four-metrics')
  save(filter(estimates,domain=='Overall',metric!='AC1'),'overall-agreement')
  save(relative,'relative-human-agreement')
  save(distribution,'rating-distribution')
  save(availability,'overall-availability')
  writeLines(c(paste('irrCAC',as.character(packageVersion('irrCAC'))),
    'Every AC1/AC2 coefficient calculated with irrCAC::gwet.ac1.table; fixed category set 1:3.',
    'Linear weights from irrCAC::linear.weights(1:3). Existing agreement_replicates for exact/kappa.',
    'Existing stratified_cluster_weights and interval_table; B=10000, seed=20261018, type 7.',
    'Human Review Overall is not independently recorded. No derived values substituted.',
    'One recorded ARBITER Overall escalation; adopted ratings retained.'),
    'provenance/posthoc-requests/methods.txt')
  invisible(estimates)
}

posthoc_display <- function(file) {
  x <- read_display(paste0('posthoc-',file))
  x <- x |> arrange(match(reference,c('Human Review 1','Human Review 2','Published labels')),
    match(domain,c('D1-D5',paste0('D',1:5),'Overall')),match(metric,c('accuracy','kappa','AC1','AC2')))
  x$value <- vapply(seq_len(nrow(x)),function(i) {
    r <- x[i,]; if(!is.finite(r$estimate)) return('Not estimable')
    scale <- if(r$metric=='accuracy') 100 else 1
    point <- if(r$metric=='accuracy' && is.finite(r$count)) fmt_fraction(r$count,r$n) else fmt_number(scale*r$estimate,if(scale==100) 1 else 2)
    paste0(point,' ',
      fmt_ci(scale*r$lower,scale*r$upper,if(scale==100) 1 else 2))
  },character(1))
  out <- x |> select(reference,domain,n,metric,source,value) |>
    pivot_wider(names_from=source,values_from=value) |>
    rename(Reference=reference,Domain=domain,N=n,Metric=metric)
  out |> select(Reference,Domain,N,Metric,ARBITER,`Direct prompting`,
    `ARBITER minus Direct prompting`,`All-Low`,any_of('Human Review 1'))
}

add_requested_posthoc_tables <- function(doc,section) {
  note <- paste('Exact agreement is n/N (%); its differences are percentage points. Coefficient differences are in coefficient units. Missing model ratings count as disagreements; missing counts are in eTable 8.',CI_NOTE)
  # Split by metric: four comparison columns stay readable on a portrait page.
  for(file in intersect(section,c('four-metrics','overall-agreement'))) {
    title <- if(file=='four-metrics') 'Agreement under four metrics' else 'Overall judgment agreement'
    number <- if(file=='four-metrics') 4L else 9L
    doc <- officer::body_add_break(doc) |> manuscript_par(paste0('eTable ',number,'. ',title),style='heading 2')
    x <- posthoc_display(file)
    hh <- filter(x,!is.na(`Human Review 1`)) |> select(Reference,Domain,N,Metric,`Human Review 1`)
    x <- x |> select(-`Human Review 1`)
    extra <- if(file=='overall-agreement') 'Recorded Overall judgments only. Human reviews have none (0/102); their comparisons exclude all trials. N includes only trials with a recorded reference; 102 minus N are excluded. ARBITER includes one adopted Overall escalation (fulop-2021). AC2 is Gwet\'s linearly weighted agreement coefficient.' else 'Kappa is Cohen\'s linearly weighted coefficient. AC1 and AC2 are Gwet\'s agreement coefficients; AC1 is unweighted and AC2 uses linear weights. Gwet coefficients use irrCAC 1.4 and all three categories.'
    for(metric in unique(x$Metric)) {
      tab <- x |> filter(Metric==metric) |> select(-Metric)
      raw <- read_display(paste0('posthoc-',file)) |> filter(.data$metric==.env$metric,n>0L,valid_replicates!=10000L)
      valid_note <- if(nrow(raw)) paste('Valid replicates are 10,000 except:',paste(paste(raw$reference,raw$domain,raw$source,raw$valid_replicates,sep=' / '),collapse='; ')) else 'All 10,000 replicates are valid for estimable comparisons; comparisons without a recorded reference have 0.'
      if(metric!=unique(x$Metric)[1]) doc <- officer::body_add_break(doc)
      doc <- manuscript_par(doc,paste(title,reader_label(metric)),style='heading 2') |>
        add_paginated_table(tab,paste(title,reader_label(metric)),paste(note,extra,valid_note),6L)
    }
    doc <- officer::body_add_break(doc) |> manuscript_par(paste(title,'between human reviews'),style='heading 2') |>
      add_paginated_table(hh,paste(title,'between human reviews'),paste(note,extra,valid_note),8L)
  }
  if(section=='relative-human-agreement') {
  x <- read_display('posthoc-relative-human-agreement')
  x$value <- paste0(fmt_number(ifelse(x$metric=='accuracy',100,1)*x$estimate,3),' ',
    fmt_ci(ifelse(x$metric=='accuracy',100,1)*x$lower,ifelse(x$metric=='accuracy',100,1)*x$upper,3))
  x <- x |> select(domain,metric,source,value) |> pivot_wider(names_from=source,values_from=value) |>
    rename(Domain=domain,Metric=metric)
  doc <- officer::body_add_break(doc) |> manuscript_par('eTable 5. Model agreement relative to human agreement',style='heading 2') |>
    add_paginated_table(x,'Model agreement relative to human agreement',paste('For each arm, D is its mean agreement with the two human reviews minus agreement between those reviews, recomputed in every resample. Exact-agreement differences are percentage points; kappa differences are in coefficient units.',CI_NOTE),12L)
  }
  if(section=='rating-distribution') {
  x <- read_display('posthoc-rating-distribution') |>
    arrange(match(domain,c('D1-D5',paste0('D',1:5),'Overall')),match(source,c('ARBITER','Direct prompting','Human Review 1','Human Review 2','Published labels'))) |>
    mutate(value=paste0(count,' (',sprintf('%.1f',percent),'%)')) |>
    select(domain,source,n,label,value) |> pivot_wider(names_from=label,values_from=value) |>
    select(domain,source,n,all_of(c(LABELS,'Missing')))
  doc <- officer::body_add_break(doc) |> manuscript_par('eTable 8. Distribution of ratings by source',style='heading 2') |>
    add_paginated_table(x,'Distribution of ratings by source','Values are counts (%). Pooled N=510; each domain and Overall N=102. Human Overall judgments were not recorded.',10L)
  }
  if(section=='overall-availability') {
  doc <- officer::body_add_break(doc) |> manuscript_par('eTable 10. Overall judgment availability',style='heading 2') |>
    add_paginated_table(read_display('posthoc-overall-availability') |> select(-analysis,-provenance),'Overall judgment availability','Recorded Overall judgments only. Human Overall judgments were not independently recorded; derived ratings are excluded.',5L)
  }
  doc
}
