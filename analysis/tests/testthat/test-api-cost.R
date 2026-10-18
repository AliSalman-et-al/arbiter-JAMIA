source(file.path(analysis_dir,'R','api-cost.R'))
test_that('Haiku prompt tier changes strictly above 100000', {
  expect_equal(haiku_tier(c(100000,100001)),c('low','high'))
})
test_that('request-tier allocation gives ordered Haiku bounds and collapsed Sonnet bounds', {
  req <- cbind(input=c(100000,100001),write1=0,write5=0,read=0)
  result <- c(input=200001,write1=0,write5=0,read=0,output=1000)
  side <- result*0
  h <- api_cost_bounds(req,result,side,'Haiku',0)
  expect_equal(unname(h),c(.0605005,.0615005,.0625005),tolerance=1e-10)
  expect_true(h['lower']<=h['point'] && h['point']<=h['upper'])
  s <- api_cost_bounds(req,result,side,'Sonnet',0)
  expect_equal(unname(s),rep(.410002,3))
})
test_that('compaction side calls use high rates and the five-minute sensitivity', {
  req <- matrix(c(10,0,0,0),nrow=1,dimnames=list(NULL,c('input','write1','write5','read')))
  r <- c(input=10,write1=0,write5=0,read=0,output=0)
  side <- c(input=0,write1=1000000,write5=0,read=0,output=0)
  expect_equal(unname(api_cost_bounds(req,r,side,'Haiku',1)),rep(1.000001,3))
  expect_equal(unname(api_cost_bounds(req,r,side,'Haiku',1,TRUE)),rep(.625001,3))
  b <- api_cost_bounds(req,r,side,'Haiku',0)
  expect_equal(unname(b),c(.200001,.200001,1.000001))
})
