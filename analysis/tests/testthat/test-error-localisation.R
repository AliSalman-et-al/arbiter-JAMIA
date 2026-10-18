test_that('independent answers are parsed without selecting conditional values', {
  x <- parse_independent_answers('1.1 = PY; 1.2=PN; 1.3=NI','D1')
  expect_equal(unname(x$answers),c('Y','N','NI'))
  expect_equal(nrow(x$issues),0L)
  x <- parse_independent_answers('3.1=N; 3.2=N; 3.3=PY; 3.4=NI at 6 months; PY at 12 months','D3')
  expect_true(is.na(x$answers['3.4']))
  expect_equal(x$issues$question,'3.4')
  expect_match(x$issues$raw,'PY at 12 months',fixed=TRUE)
  expect_equal(nrow(parse_independent_answers(NA_character_,'D1')$issues),1L)
  expect_equal(nrow(parse_independent_answers('unrecognised','D1')$issues),1L)
  x <- parse_independent_answers('1.1=Y; 1.1=N; 1.2=perhaps; 2.1=Y','D1')
  expect_true(all(is.na(x$answers)))
  expect_setequal(x$issues$issue,c('Duplicate assignment','Ambiguous or unrecognised answer',
    'Question outside cell domain','Missing question'))
  expect_equal(collapse_localisation_answer(c('PY','PN','NI','NA','not_applicable','no_information')),
    c('Y','N','NI','NA','NA','NI'))
})

test_that('all six ordered classes use substitutions in otherwise unchanged answers', {
  low <- c('1.1'='Y','1.2'='Y','1.3'='N')
  one <- low; one['1.1'] <- 'N'
  classify <- function(label,preferred,answer,reference,domain='D1')
    classify_losing_cell(domain,label,preferred,answer,list(A=reference,Z=reference))
  # A Baseline reported judgement disagrees with its own complete answer path;
  # class 1 wins even though a reference substitution is decisive.
  x <- classify('High','Some concerns',low,one)
  expect_equal(x$class,LOCALISATION_CLASSES[1])
  expect_equal(x$own_algorithm,'Low')
  x <- classify('Low','Some concerns',low,one)
  expect_equal(x$class,LOCALISATION_CLASSES[2])
  expect_equal(x$decisive_questions,'1.1')
  several <- c('1.1'='N','1.2'='NI','1.3'='Y')
  x <- classify('Low','High',low,several)
  expect_equal(x$class,LOCALISATION_CLASSES[3])
  expect_equal(x$decisive_questions,'1.1; 1.2; 1.3')
  joint <- c('5.1'='NI','5.2'='Y','5.3'='Y')
  reference <- c('5.1'='NI','5.2'='N','5.3'='N')
  x <- classify('High','Some concerns',joint,reference,'D5')
  expect_equal(x$class,LOCALISATION_CLASSES[4])
  expect_equal(x$decisive_questions,'')
  expect_equal(x$discordant_questions,'5.2; 5.3')
  expect_equal(x$all_substitutions_algorithm,'Some concerns')
  # ARBITER can agree on every answer while adjudicators prefer another label.
  x <- classify('Low','Some concerns',low,low)
  expect_equal(x$class,LOCALISATION_CLASSES[5])
  expect_equal(x$discordant_questions,'')
  expect_equal(x$reference_judgement_departs,'A; Z')
  other <- low; other['1.3'] <- 'NI'
  x <- classify('Low','High',low,other)
  expect_equal(x$class,LOCALISATION_CLASSES[6])
})

test_that('disagreement, unparsed answers and invalid paths are explicit', {
  low <- c('1.1'='Y','1.2'='Y','1.3'='N')
  different <- low; different['1.1'] <- 'N'
  x <- classify_losing_cell('D1','Low','Some concerns',low,list(A=low,Z=different))
  expect_equal(x$adjudicators_differ,'1.1')
  expect_equal(x$discordant_questions,'')
  missing <- low; missing['1.1'] <- NA_character_
  x <- classify_losing_cell('D1','Low','Some concerns',low,list(A=missing))
  expect_equal(x$unresolved_reference_questions,'1.1')
  expect_equal(x$class,LOCALISATION_CLASSES[6])
  x <- classify_losing_cell('D1','Low','Some concerns',missing,list(A=different))
  expect_equal(x$class,LOCALISATION_CLASSES[1])
  expect_true(is.na(x$own_algorithm))
  # A changed upstream answer can require a previously NA downstream answer.
  arm <- c('3.1'='Y','3.2'='NA','3.3'='NA','3.4'='NA')
  ref <- c('3.1'='N','3.2'='N','3.3'='Y','3.4'='Y')
  x <- classify_losing_cell('D3','Low','High',arm,list(A=ref))
  expect_match(x$invalid_substitutions,'3.1',fixed=TRUE)
  expect_equal(x$class,LOCALISATION_CLASSES[4])
  expect_equal(x$decisive_questions,'')
})

test_that('eligibility is judgement equality and sensitivity includes one usable adjudicator', {
  adj <- tibble(slug=rep(c('both','one','neither'),each=2),domain='D1',
    adjudicator=rep(c('A','Z'),3),own=c('Some concerns','Some concerns','Some concerns','High','High','High'),
    chosen_label='Some concerns',signalling_answers_independent='1.1=N; 1.2=Y; 1.3=N',
    adjudication_explanation=rep(c('Full A text','Full Z text'),3))
  labels <- cross_join(tibble(slug=c('both','one','neither'),domain='D1',meta_id='test',meta='Some concerns'),
    tibble(arm=c('ARBITER-Sonnet','Baseline-Sonnet'),label='Low'))
  signals <- cross_join(select(labels,slug,domain,arm),
    tibble(question=c('1.1','1.2','1.3'),answer=c('yes','yes','no'),active=TRUE))
  data <- list(adjud=adj,labels=labels,signals=signals)
  x <- localise_errors(data)
  expect_true(all(x$eligibility$primary[x$eligibility$source!='Meta']==1))
  expect_true(all(x$eligibility$sensitivity[x$eligibility$source!='Meta']==2))
  expect_equal(nrow(filter(x$cells,population=='Primary')),2L)
  expect_equal(nrow(filter(x$cells,population=='Sensitivity')),4L)
  expect_false('neither' %in% x$cells$slug)
  expect_equal(filter(x$cells,slug=='one')$usable_adjudicators,c('A','A'))
  expect_true(all(x$candidates$adjudication_explanation_A=='Full A text'))
  expect_true(all(x$candidates$adjudication_explanation_Z=='Full Z text'))
  expect_equal(x$candidates,localise_errors(data)$candidates)
})

test_that('observed losses reproduce the independent lead counts', {
  x <- localise_errors(inputs)
  expect_equal(x$eligibility$consensus_losses,c(13L,60L,100L))
  expect_equal(x$eligibility$primary[1:2],c(10L,47L))
  expect_equal(x$eligibility$sensitivity[1:2],c(12L,57L))
  expect_equal(nrow(x$issues),1L)
  expect_equal(x$issues$slug,'chiba-2021')
  expect_false('chiba-2021' %in% x$cells$slug[x$cells$domain=='D3'])
  totals <- x$counts |> group_by(population,source) |> summarise(n=sum(n),.groups='drop')
  expect_equal(totals$n,c(10L,47L,12L,57L))
  expect_equal(nrow(x$candidates),10L)
  expect_true(all(x$candidates$class=='Single decisive question'))
  expect_true(all(x$candidates$primary))
})
