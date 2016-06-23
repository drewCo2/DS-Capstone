
if(!exists("testCases"))
{
  
 
# Let's get some test data together to see if we can evaluate our accuracy...
library(quanteda)
library(dplyr)

source("begin.r")
source("ModelFuncs.R")

dir<-'./DataFiles/en_US'
files<-list.files(dir, full.names = TRUE)

set.seed(123)
sampleSize = 500
sampleSet<-getSampleSet(files, sampleSize, cache.files = TRUE)

testCount<-500
allLines <- c(sampleSet)

testLines<-sapply(allLines[sample(1:testCount)], toLower)

# Get all of the lines tokenized.
allt<-sapply(testLines, function(x) tokenize(x, removeNumbers=TRUE, removeHyphens = TRUE, removePunct=TRUE, removeTwitter=TRUE, simplify=TRUE))

testInputs<-sapply(allt, function(x)
{
  # it would be good to be able to get a few words from each line.
  len<-length(x)
  ti<-paste(x[1:len-1], collapse = " ")
  ti
})

testAnswers<-as.character(sapply(allt, function(x)
{
  len<-length(x)
  ans<-x[len]
}))

testCases<-data.frame(input=testInputs, answer=testAnswers, stringsAsFactors = FALSE)

# saveRDS(testCases, "test-cases.RDS")

}


# Let's run some test cases.....
runTests<-function(model, tests)
{
  results<-tests
  results<-mutate(results, guess = guessWord(model, input)$bestWord)
  results<-mutate(results, pass = guess == answer)
  results
}


