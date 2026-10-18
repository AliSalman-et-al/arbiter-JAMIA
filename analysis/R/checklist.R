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
  bind_rows(tripod,grras) |> mutate(page='',section='',applicability_and_notes='') |>
    select(guideline,item,topic,page,section,applicability_and_notes,source)
}
