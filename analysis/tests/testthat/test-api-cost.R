source(file.path(analysis_dir,'R','api-cost.R'))
test_that('Sonnet API reconstruction bounds coincide at the frozen rate card', {
  req <- data.frame(input=100000,write1=100000,write5=0,read=100000)
  result <- c(input=100000,write1=100000,write5=0,read=100000,output=100000)
  side <- c(input=0,write1=0,write5=0,read=0,output=0)
  b <- api_cost_bounds(req,result,side,'Sonnet',0)
  expect_equal(unname(b),rep(1.61,3))
})
