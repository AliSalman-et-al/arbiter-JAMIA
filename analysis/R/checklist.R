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
    '1'='Pending manuscript title','2'='Pending manuscript abstract','3a'='Pending manuscript background',
    '3b'='Pending manuscript objectives and discussion','4'='Pending manuscript objectives',
    '5a'='eMethods Benchmark and supplied inputs; Targets and input parity; Linked benchmark source records',
    '5b'='Table 1; eTable 3','5c'='Text-date coverage not reported; author information required',
    '5d'='eMethods Evidence records and source verification','5e'='eMethods Signalling mapping and eligibility; eTable 4B',
    '6a'='Prompt templates and run provenance','6b'='Prompt templates and run provenance; complete development history requires author information',
    '6c'='Prompt templates and run provenance','6d'='eMethods Algorithms and validation; Figures 1 and 2',
    '6e'='eMethods Algorithms and validation','7a'='Figures 4 and 5; Tables 2 and 3; eTables 1 to 4',
    '7b'='eMethods Inference and Exploratory diagnostic checks','7c'='eMethods Targets and input parity',
    '7d'='eMethods Blinded human assessment; individual credentials require author information',
    '7e'='eMethods Benchmark and supplied inputs; Prompt templates and run provenance',
    '8a'='eMethods Blinded human assessment; original blank form and multi-outcome conventions require author information',
    '8b'='Figure 4; eTable 2','8c'='eMethods Blinded human assessment; individual experience/calibration require author information',
    '9a'='Prompt templates and run provenance; prompt selection and version-freeze history require author information',
    '9b'='Prompt templates and run provenance; author-attested benchmark non-use and bounded development records',
    '10'='N/A: no summarization task; source parsing in eMethods Evidence records and source verification',
    '11'='N/A: no instruction tuning or alignment training','12'='Table 3; eMethods Runtime and API equivalents; linked API ledgers',
    '13'='Pending manuscript ethics declaration; author confirmation required','14a'='Pending manuscript funding statement; author confirmation required',
    '14b'='Pending manuscript competing interests; author confirmation required','14c'='eMethods Reporting scope; archive identifier requires author confirmation',
    '14d'='Pending manuscript registration statement; author confirmation required',
    '14e'='Linked source records and reproducibility materials; pending manuscript data availability statement',
    '14f'='Prompt templates and run provenance; pending manuscript code availability statement','15'='Pending manuscript public involvement statement; author confirmation required',
    '16a'='Figure 3','16b'='Table 1; Linked benchmark source records','16c'='Table 1; Linked benchmark source records; report-level benchmark without patient-level distributions',
    '16d'='Figure 3; Table 1','17'='Figures 4 and 5; Tables 2 and 3; eTables 1 to 4',
    '18'='N/A: no model updating or adaptation','19a'='Pending manuscript discussion','19b'='eMethods Inference; pending manuscript limitations',
    '19c'='eMethods Targets and input parity','19d'='Pending manuscript discussion','19e'='Table 3; eMethods Targets and input parity',
    '19f'='Pending manuscript discussion','19g'='Pending manuscript discussion')
  tripod <- tripod |> mutate(section=unname(locations[item]))
  grras <- grras |> mutate(section=c('Pending manuscript title and abstract','eMethods Algorithms and validation',
    'Table 1; Linked benchmark source records','eMethods Blinded human assessment; individual credentials require author information',
    'Pending manuscript objectives','eMethods Benchmark and supplied inputs; available purposive sample',
    'eMethods Benchmark and supplied inputs; search records require author information',
    'Figure 3; eMethods Blinded human assessment','eMethods Blinded human assessment',
    'eMethods Inference; Exploratory diagnostic checks','Figure 3; Table 1',
    'Table 1; eMethods Blinded human assessment','Figures 4 and 5; eTables 1 to 4',
    'Pending manuscript discussion','eTables 1 to 4; Linked source records and reproducibility materials'))
  bind_rows(tripod,grras) |> mutate(page='Stable section/display locator',
    applicability_and_notes=case_when(
      startsWith(section,'N/A:')~'Not applicable to this evaluation',
      grepl('author information|author confirmation|[Pp]ending manuscript',section)~'Partial or pending; see retained materials and author-completion notes',
      TRUE~'Reported at the named section or display')) |>
    select(guideline,item,topic,page,section,applicability_and_notes,source)
}
