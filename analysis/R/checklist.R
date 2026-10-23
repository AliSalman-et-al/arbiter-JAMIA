reporting_checklist <- function() {
  tripod <- tibble::tribble(
    ~item,~topic,
    '1','Title','2','Abstract','3a','Context','3b','Intended users','4','Objectives',
    '5a','Data sources','5b','Data distribution','5c','Text dates','5d','Preprocessing','5e','Missingness',
    '6a','Model identity','6b','Development','6c','Inference settings','6d','Outputs','6e','Classification',
    '7a','Generative metrics','7b','Metric relevance','7c','Outcome definition','7d','Assessors','7e','Comparators',
    '8a','Annotation guidance','8b','Annotation agreement','8c','Annotator experience',
    '9a','Prompt design','9b','Prompt data','10','Summarization preprocessing','11','Alignment evaluation',
    '12','Compute','13','Ethics','14a','Funding','14b','Conflicts','14c','Protocol','14d','Registration',
    '14e','Data access','14f','Code access','15','Public involvement',
    '16a','Data flow','16b','Data characteristics','16c','Clinical distributions','16d','Analysis counts',
    '17','Performance','18','Model updating','19a','Interpretation','19b','Limitations','19c','Data challenges',
    '19d','Implementation scope','19e','Poor inputs','19f','User expertise','19g','Future research') |>
    mutate(guideline='TRIPOD-LLM',source='https://www.tripod-statement.org/wp-content/uploads/2025/01/TRIPOD-LLM-Checklist.pdf')
  grras <- tibble(item=as.character(1:15),topic=c('Title/abstract identification','Measurement instrument',
    'Subject population','Rater population','Rationale','Sample size rationale','Sampling',
    'Rating process and blinding','Independent ratings','Statistical methods','Actual sample counts',
    'Sample/rater characteristics','Estimates and uncertainty','Practical relevance','Detailed results'),
    guideline='GRRAS',source='https://www.equator-network.org/wp-content/uploads/2012/12/GRRAS-checklist-for-reporting-of-studies-of-reliability-and-agreement.pdf')
  locations <- c(
    '1'='Manuscript title (ANALYSIS-PLAN section 7)',
    '2'='Manuscript abstract; results-sentences.md (author assembly)',
    '3a'='Manuscript Background and significance (author assembly; ANALYSIS-PLAN section 7)',
    '3b'='Manuscript Background and significance; eMethods Interpretive limits',
    '4'='eMethods Blinded expert assessment',
    '5a'='eMethods Input parity and label targets; supplementary table',
    '5b'='Supplement section 1 Benchmark trials', '5c'='eMethods Interpretive limits',
    '5d'='eMethods Algorithms and validation; prompt templates',
    '5e'='eMethods Independent reference and Overall; supplement section 5',
    '6a'='Supplement Prompt templates and run provenance; eMethods Interpretive limits',
    '6b'='N/A: fixed provider model; no model development or fine-tuning',
    '6c'='Supplement Prompt templates and run provenance', '6d'='eMethods Algorithms and validation; prompt templates',
    '6e'='eMethods Algorithms and validation; Input parity and label targets',
    '7a'='Table 3; eMethods Evidence binding and verification',
    '7b'='eMethods Blinded expert assessment; Independent reference and Overall',
    '7c'='eMethods Input parity and label targets',
    '7d'='eMethods Blinded expert assessment; Manuscript Methods rater credentials (author completion required)',
    '7e'='eMethods Input parity and label targets; prompt templates; Table 3',
    '8a'='eMethods Algorithms and validation; Blinded expert assessment',
    '8b'='Figure 4; supplement sections 2 and 5',
    '8c'='Manuscript Methods rater credentials (author completion required)',
    '9a'='Supplement Prompt templates and run provenance',
    '9b'='Supplement Prompt templates and run provenance; supplementary table',
    '10'='N/A: no summarisation task; source parsing described in eMethods Evidence binding and verification',
    '11'='N/A: no instruction tuning or alignment training was performed',
    '12'='Supplement Prompt templates and run provenance; eMethods API list-price reconstruction; time/cost eTables',
    '13'='Manuscript Ethics declaration (author completion required)',
    '14a'='Manuscript Funding declaration (author completion required)',
    '14b'='Manuscript Competing interests (author completion required)',
    '14c'='eMethods Independent reference and Overall; evaluation outcomes organized after analysis without a confirmatory hierarchy in Methods',
    '14d'='Manuscript Protocol/registration statement (author confirmation required)',
    '14e'='Manuscript Data availability; Results report Reproduction',
    '14f'='Results report Reproduction; Supplement Prompt templates and run provenance',
    '15'='Manuscript Public involvement statement (author confirmation required)',
    '16a'='Figure 3', '16b'='supplementary table', '16c'='supplementary table; N/A for individual-patient distributions: report-level benchmark',
    '16d'='Figure 3; Tables 1–3', '17'='Figures 4–5; Tables 1–3; supplementary table full contrasts; supplementary table signalling questions and disagreement types; eFigure 2 collapsed question differences; eFigure 5 five-level and collapsed differences; eFigure 4 source-specific signalling agreement',
    '18'='N/A: no model updating or adaptation was performed',
    '19a'='Manuscript Discussion (author assembly); results-sentences.md',
    '19b'='eMethods Interpretive limits', '19c'='eMethods Input parity and label targets; Interpretive limits',
    '19d'='eMethods Interpretive limits; Manuscript Discussion deployment (author assembly)',
    '19e'='Table 3; eMethods Algorithms and validation; Interpretive limits',
    '19f'='Manuscript Discussion human oversight (author assembly)',
    '19g'='Manuscript Discussion future work (author assembly)')
  tripod <- tripod |> mutate(section=unname(locations[item]))
  grras_locations <- c('Manuscript title and abstract (author assembly)',
    'eMethods Algorithms and validation','supplementary table; Figure 3',
    'Manuscript Methods rater credentials (author completion required)',
    'eMethods Blinded expert assessment',
    'Benchmark README-FOR-ALI.md sampling; Figure 3 (fixed available sample)',
    'supplementary table; benchmark README-FOR-ALI.md',
    'eMethods Blinded expert assessment',
    'Table 1; eMethods Blinded expert assessment',
    'eMethods Independent reference and Overall','Figure 3; Table 1',
    'supplementary table; Manuscript Methods rater credentials (author completion required)',
    'Tables 1–3; Figures 4–5','Manuscript Discussion (author assembly)',
    'Supplementary analyses; results.html; repository CSVs')
  grras <- grras |> mutate(section=grras_locations)
  map <- bind_rows(tripod,grras)
  map$section <- gsub(' [(](author assembly|ANALYSIS-PLAN)[^)]*[)]','',map$section)
  map$section <- gsub('results-sentences.md','Manuscript Results',map$section,fixed=TRUE)
  map$section <- gsub('Benchmark README-FOR-ALI.md sampling; Figure 3 (fixed available sample)','Manuscript Benchmark and assessment arms; Figure 3; eTable 1 (fixed available benchmark)',map$section,fixed=TRUE)
  map$section <- gsub('benchmark README-FOR-ALI.md','Manuscript Benchmark and assessment arms',map$section,fixed=TRUE)
  map$section <- gsub('supplementary table full contrasts','eTable 2 and eTable 16',map$section,fixed=TRUE)
  map$section <- gsub('supplementary table signalling questions and disagreement types','eTables 13, 13A and 13B',map$section,fixed=TRUE)
  map$section <- gsub('supplementary table','eTable 1',map$section,fixed=TRUE)
  map$section <- gsub('time/cost eTables','eTables 20–22',map$section,fixed=TRUE)
  map$section[map$guideline=='TRIPOD-LLM' & map$item=='5c'] <- 'Text-date coverage is not reported; author information required'
  map$section[map$guideline=='TRIPOD-LLM' & map$item=='14c'] <- 'Manuscript Statistical analysis; evaluation outcomes organized after analysis without a confirmatory hierarchy; protocol/archive identifier requires author confirmation'
  map$section[map$guideline=='GRRAS' & map$item=='9'] <- 'Manuscript Independent expert references; eMethods Blinded expert assessment'
  map$section[map$guideline=='TRIPOD-LLM' & map$item=='5a'] <- 'eMethods Input parity and label targets; Benchmark construction and exclusions; eTable 1; author-supplied purposive selection; search dates, ranking records and additional-review rationale unrecovered'
  map$section[map$guideline=='TRIPOD-LLM' & map$item=='8a'] <- 'eMethods Algorithms and validation; Blinded expert assessment; matched materials and task confirmed by author; original form and multi-outcome conventions unprovided'
  map$section[map$guideline=='TRIPOD-LLM' & map$item=='9a'] <- 'Supplement Prompt templates and run provenance; prompt design, selection and version-freeze provenance require author completion'
  map$section[map$guideline=='TRIPOD-LLM' & map$item=='9b'] <- 'Supplement Prompt templates and run provenance; eTable 1; ten prostate-cancer development trials and synthetic cases retained in ARBITER eval/; benchmark non-use author-attested; complete exposure history and independent overlap audit unestablished'
  map$section[map$guideline=='GRRAS' & map$item=='7'] <- 'eTable 1; Manuscript Benchmark and assessment arms; eMethods Input parity and label targets; purposive selection and table-order sampling; search records unrecovered'
  map$section[map$guideline=='GRRAS' & map$item=='8'] <- 'eMethods Blinded expert assessment; same materials and task as model arms; Cochrane RoB 2 guidance; original form and multi-outcome conventions unprovided'
  map <- map |> mutate(page='Stable section/display locator',
    applicability_and_notes=case_when(
      guideline=='TRIPOD-LLM' & item=='5a'~'Partial: purposive selection reported by author; search and ranking records unrecovered',
      guideline=='TRIPOD-LLM' & item=='8a'~'Partial: matched task and guidance reported; original form and multi-outcome conventions unprovided',
      guideline=='TRIPOD-LLM' & item=='9a'~'Partial: final templates do not establish the prompt-development process',
      guideline=='TRIPOD-LLM' & item=='9b'~'Partial: author attestation of benchmark non-use; retained records do not establish exhaustive exposure history or a complete independent overlap audit',
      guideline=='GRRAS' & item=='7'~'Partial: author-supplied purposive selection and within-review sampling reported; search records unrecovered',
      guideline=='GRRAS' & item=='8'~'Partial: matched materials, task and guidance confirmed by author; original form and multi-outcome conventions unprovided',
      startsWith(section,'N/A:')~'Not applicable: fixed model and task',
      grepl('author completion|author confirmation|author information|author information required',section,ignore.case=TRUE)~'Partial: author information required',
      TRUE~'Reported at the named current section or display'))
  map |> select(guideline,item,topic,page,section,applicability_and_notes,source)
}
