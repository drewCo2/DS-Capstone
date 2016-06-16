# This file creates our prediction 'model' for the n-gram analyzer.
# We are going to do some sampling / training, and create a type of table that we will use to make
# predictions.

# A lot of this content was taken from the exploration and assignment files.

rm(list=ls())

source("begin.R")
source("ModelFuncs.R")

library(quanteda)
library(dplyr)

# defs
COLS<-2


# The files that we will need...
dir<-'./DataFiles/en_US'
files<-list.files(dir, full.names = TRUE)


# We can read all of the lines in for processing.
lineGroups <- sapply(files, readAllLines)


# Now we can do the sampling...
# Seed / Sample lines per file.
set.seed(1234)
sampleSize<-100
sampleSet<- sapply(lineGroups, function(x) sample(x, sampleSize))

# We will merge all docs into a single one, which we will then tokenize.  From there we will
# generate our n-grams.
docSets<-apply(sampleSet, MARGIN=COLS, createDoc)

allTokens<-tokenize(paste(docSets, collapse=" "), removeNumbers=TRUE, removeHyphens = TRUE, removePunct=TRUE, removeTwitter=TRUE, simplify=TRUE)

ngram_1 <- ngramDF(allTokens, 1)
ngram_2 <- ngramDF(allTokens, 2)
ngram_3 <- ngramDF(allTokens, 3)
ngram_4 <- ngramDF(allTokens, 4)


# Given a set of ngrams, with terms and counts, this will decompose it into a data frame with probabilites
# for the next word given n-1 tokens.
makeNgDf<-function(ngrams, gramSize)
{
  # create the data frame of the appropriate size.
  cNames<-sapply(1:gramSize, function(x) paste0("t", x))
  cNames<-c(cNames, "p")
  
  splitRow<-function(row)
  {
    res<-unlist(strsplit(row[[1]], split=" "))
    res<-c(res, row[[2]])
    res
  }
  mat<-apply(ngram_2, MARGIN=1, splitRow)

  # note that we are transposing our matrix.
  res<-data.frame(t(mat)) 
  names(res)<-cNames
  
  
  res<-arrange(res, t1, t2, desc(p))
  
  # Limit results for testing.
#  res<-res[1:5,]
  res
}

x<-makeNgDf(ngram_2, 2)
sel<-(x$t1=="of" & x$t2 == "the")
x[sel,]


# View(x)

sel<-x$t1=="of" && x$t2=="the"
y<-x[sel,]



n<-ngram_2
s<-n[1,1]
sp<-unlist(strsplit(s, split=" "))
class(sp)
sp

splitRow<-function(row)
{
  res<-unlist(strsplit(row[[1]], split=" "))
  res<-c(res, row[[2]])
  res
}
x<-apply(ngram_2, MARGIN=1, splitRow)


nr1<-ngram_2[1,1:2]
splitRow(r1)


splitRow(r1)

r1<-ngram_2[1,]
x<-unlist(strsplit(r1[[1]], split=" "))
x<-c(x, r1[[2]])
x


x<- makeNgDf(ngram_2)
x



# We certainly don't want stats on everything that appears in our tables.  We should take a certain percentage of each,
# depending on our needs.  The more we have, the more lookup space to traverse, but less chance of missing a word.

# We will take some percentage of the matches, from the top.
# This should be small since the distribution of matches will fall off quickly.
# We could also experiment with selectiong top-n, or by min. Count.
takeTopPct <- .05;


# NOTE: We actually only need a few of the top unigrams as they are fallback for a
# no-match situation.
MAX<-5000

#top_1<-selectTopN(ngram_1, MAX)
#top_2<-selectTopN(ngram_2, MAX)
#top_3<-selectTopN(ngram_3, MAX)
#top_4<-selectTopN(ngram_4, MAX)

MIN<-4

top_1mc<-selectMinCount(ngram_1, MIN, MAX)
top_2mc<-selectMinCount(ngram_2, MIN, MAX)
top_3mc<-selectMinCount(ngram_3, MIN, MAX)
top_4mc<-selectMinCount(ngram_4, MIN, MAX)

# Hmmm.... based on observations, it seems that we start seeing the higer n-grams ending with sequences from the lower n-grams.
# I guess this is where the back-track (or whatever) model would come into play....

boxplot(ngram_1$Count, ngram_2$Count, ngram_3$Count)
boxplot(top_1$Count, top_2$Count, top_3$Count)
#ngram_2 <- ngrams(allTokens, 2)
#ngram_3 <- ngrams(allTokens, 3)

