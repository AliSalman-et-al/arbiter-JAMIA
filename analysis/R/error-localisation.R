# Section 5.6 uses four answer categories, independently of section 6.
collapse_localisation_answer <- function(x) {
  codes <- c(Y='Y',PY='Y',N='N',PN='N',NI='NI','NA'='NA',
    yes='Y',probably_yes='Y',no='N',probably_no='N',
    no_information='NI',not_applicable='NA')
  unname(codes[x])
}
localisation_algorithm <- function(domain,answers) {
  values <- c(Y='yes',N='no',NI='no_information','NA'='not_applicable')
  domain_algorithm(domain,setNames(unname(values[answers]),names(answers)))
}

# Split on numbered assignments rather than semicolons: a qualifier can itself
# contain a semicolon. Never silently select the first conditional/time value.
parse_independent_answers <- function(text,domain) {
  questions <- question_map()$question
  questions <- questions[startsWith(questions,paste0(sub('D','',domain),'.'))]
  answers <- setNames(rep(NA_character_,length(questions)),questions)
  issues <- tibble(question=character(),raw=character(),issue=character())
  add_issue <- function(q,raw,why) {
    issues <<- bind_rows(issues,tibble(question=q,raw=raw,issue=why))
  }
  if(is.na(text)||!nzchar(trimws(text))) {
    add_issue('',coalesce(text,''),'Missing answer string')
    return(list(answers=answers,issues=issues))
  }
  locations <- gregexpr('[0-9]+[.][0-9]+\\s*=',text,perl=TRUE)[[1]]
  if(locations[1]<0) {
    add_issue('',text,'No numbered assignments')
    return(list(answers=answers,issues=issues))
  }
  prefix <- substr(text,1,locations[1]-1)
  if(nzchar(trimws(prefix))) add_issue('',prefix,'Unparsed prefix')
  ends <- c(locations[-1]-1,nchar(text))
  seen <- character()
  for(i in seq_along(locations)) {
    token <- substr(text,locations[i],ends[i])
    q <- trimws(sub('=.*','',token))
    value <- trimws(sub('[;,\\s]+$','',sub('^[^=]*=\\s*','',token),perl=TRUE))
    if(!q %in% questions) { add_issue(q,token,'Question outside cell domain'); next }
    if(q %in% seen) {
      answers[q] <- NA_character_
      add_issue(q,token,'Duplicate assignment'); next
    }
    seen <- c(seen,q)
    if(!value %in% c('Y','PY','N','PN','NI','NA')) {
      add_issue(q,token,'Ambiguous or unrecognised answer'); next
    }
    answers[q] <- collapse_localisation_answer(value)
  }
  for(q in setdiff(questions,seen)) add_issue(q,'','Missing question')
  list(answers=answers,issues=issues)
}

LOCALISATION_CLASSES <- c('Judgement departs from own answers','Single decisive question',
  'Several decisive questions','Jointly decisive','Answers agree, judgement differs','Not attributable')

classify_losing_cell <- function(domain,label,preferred,answers,references) {
  stopifnot(length(references)>0)
  questions <- question_map()$question
  questions <- questions[startsWith(questions,paste0(sub('D','',domain),'.'))]
  answers <- setNames(unname(answers[questions]),questions)
  own_algorithm <- localisation_algorithm(domain,answers)
  reference_matrix <- vapply(references,function(x) unname(x[questions]),character(length(questions)))
  complete <- rowSums(is.na(reference_matrix))==0
  agree <- complete & apply(reference_matrix,1,function(x) length(unique(x))==1)
  differ <- complete & !agree
  reference <- setNames(reference_matrix[,1],questions)
  comparable <- agree & !is.na(answers)
  discordant <- questions[comparable & answers!=reference]
  substitutions <- vapply(discordant,function(q) {
    changed <- answers; changed[q] <- reference[q]
    localisation_algorithm(domain,changed)
  },character(1))
  # An invalid substituted path is not an algorithm judgement.
  decisive <- discordant[!is.na(substitutions) & !is.na(own_algorithm) & substitutions!=own_algorithm]
  together <- answers; together[discordant] <- reference[discordant]
  joint_algorithm <- localisation_algorithm(domain,together)
  class <- if(is.na(own_algorithm)||is.na(label)||label!=own_algorithm) LOCALISATION_CLASSES[1] else
    if(length(decisive)==1) LOCALISATION_CLASSES[2] else
    if(length(decisive)>1) LOCALISATION_CLASSES[3] else
    if(length(discordant)>0 && !is.na(joint_algorithm) && joint_algorithm==preferred) LOCALISATION_CLASSES[4] else
    if(!length(discordant) && all(complete) && !anyNA(answers)) LOCALISATION_CLASSES[5] else LOCALISATION_CLASSES[6]
  ref_algorithm <- vapply(references,function(x) localisation_algorithm(domain,x),character(1))
  join <- function(x) paste(x,collapse='; ')
  tibble(class=class,own_algorithm=own_algorithm,
    discordant_questions=join(discordant),adjudicators_differ=join(questions[differ]),
    unresolved_reference_questions=join(questions[!complete]),
    decisive_questions=join(decisive),invalid_substitutions=join(discordant[is.na(substitutions)]),
    all_substitutions_algorithm=joint_algorithm,
    reference_algorithm=join(paste0(names(references),'=',coalesce(ref_algorithm,'Invalid answer path'))),
    reference_judgement_departs=join(names(references)[is.na(ref_algorithm)|ref_algorithm!=preferred]))
}

localise_errors <- function(inputs,cells=adjudication_cells(inputs)) {
  parsed <- lapply(seq_len(nrow(inputs$adjud)),function(i)
    parse_independent_answers(inputs$adjud$signalling_answers_independent[i],inputs$adjud$domain[i]))
  issues <- bind_rows(lapply(seq_along(parsed),function(i) bind_cols(
    inputs$adjud[rep(i,nrow(parsed[[i]]$issues)),c('slug','domain','adjudicator')],parsed[[i]]$issues)))
  losses <- cells |> filter(consensus) |>
    select(slug,domain,preferred,meta,ARBITER_label=kit,Baseline_label=nokit,own_A,own_Z) |>
    mutate(`ARBITER-Sonnet`=ARBITER_label,`Baseline-Sonnet`=Baseline_label) |>
    pivot_longer(c(`ARBITER-Sonnet`,`Baseline-Sonnet`),names_to='source',values_to='losing_label') |>
    filter(is.na(losing_label)|losing_label!=preferred) |>
    mutate(usable_A=own_A==preferred,usable_Z=own_Z==preferred)
  classified <- bind_rows(lapply(seq_len(nrow(losses)),function(i) {
    cell <- losses[i,]
    usable <- c('A','Z')[c(cell$usable_A,cell$usable_Z)]
    if(!length(usable)) return(NULL)
    idx <- which(inputs$adjud$slug==cell$slug & inputs$adjud$domain==cell$domain &
      inputs$adjud$adjudicator %in% usable)
    references <- setNames(lapply(idx,function(j) parsed[[j]]$answers),inputs$adjud$adjudicator[idx])
    signal <- inputs$signals |> filter(arm==cell$source,slug==cell$slug,domain==cell$domain)
    stopifnot(!anyDuplicated(signal$question))
    result <- classify_losing_cell(cell$domain,cell$losing_label,cell$preferred,
      setNames(collapse_localisation_answer(signal$answer),signal$question),references)
    bind_cols(cell,tibble(usable_adjudicators=paste(usable,collapse='; ')),result)
  }))
  populations <- bind_rows(classified |> filter(usable_A & usable_Z) |> mutate(population='Primary'),
    classified |> mutate(population='Sensitivity'))
  counts <- populations |> count(population,source,class) |>
    complete(population=c('Primary','Sensitivity'),source=c('ARBITER-Sonnet','Baseline-Sonnet'),
      class=LOCALISATION_CLASSES,fill=list(n=0)) |>
    mutate(class_order=match(class,LOCALISATION_CLASSES)) |> arrange(population,source,class_order)
  frequency <- populations |> filter(nzchar(decisive_questions)) |>
    select(population,source,domain,decisive_questions) |>
    separate_longer_delim(decisive_questions,delim='; ') |> rename(question=decisive_questions) |>
    count(population,source,domain,question) |>
    right_join(cross_join(tibble(population=c('Primary','Sensitivity'),source='ARBITER-Sonnet') |>
      bind_rows(tibble(population=c('Primary','Sensitivity'),source='Baseline-Sonnet')),
      question_map(include_short_text=TRUE) |> mutate(domain=paste0('D',substr(question,1,1)))),
      by=c('population','source','domain','question')) |>
    mutate(n=coalesce(n,0L)) |> select(-question_id) |> arrange(population,source,question)
  explanations <- inputs$adjud |> select(slug,domain,adjudicator,adjudication_explanation) |>
    pivot_wider(names_from=adjudicator,values_from=adjudication_explanation,
      names_glue='adjudication_explanation_{adjudicator}')
  # Five per source: primary first, then single-decisive, then class order,
  # then slug/domain. Selection never reads or ranks the explanation text.
  candidates <- classified |> mutate(primary=usable_A & usable_Z,
      selection_rank=if_else(class==LOCALISATION_CLASSES[2],0L,match(class,LOCALISATION_CLASSES))) |>
    arrange(source,desc(primary),selection_rank,slug,domain) |>
    group_by(source) |> slice_head(n=5) |> ungroup() |> select(-selection_rank) |>
    left_join(explanations,by=c('slug','domain'))
  eligibility <- losses |> group_by(source) |> summarise(consensus_losses=n(),
    primary=sum(usable_A & usable_Z),sensitivity=sum(usable_A|usable_Z),.groups='drop')
  eligibility <- bind_rows(eligibility,tibble(source='Meta',
    consensus_losses=sum(cells$consensus & cells$meta!=cells$preferred,na.rm=TRUE),
    primary=NA_integer_,sensitivity=NA_integer_))
  list(cells=populations,counts=counts,frequency=frequency,issues=issues,
    candidates=candidates,eligibility=eligibility)
}
