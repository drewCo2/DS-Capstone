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
sampleSize<-1000
sampleSet<- sapply(lineGroups, function(x) sample(x, sampleSize))

# We will merge all docs into a single one, which we will then tokenize.  From there we will
# generate our n-grams.
docSets<-apply(sampleSet, MARGIN=COLS, createDoc)

allTokens<-tokenize(paste(docSets, collapse=" "), removeNumbers=TRUE, removeHyphens = TRUE, removePunct=TRUE, removeTwitter=TRUE, simplify=TRUE)

ngram_1 <- ngramDF(allTokens, 1)
ngram_2 <- ngramDF(allTokens, 2)
ngram_3 <- ngramDF(allTokens, 3)
ngram_4 <- ngramDF(allTokens, 4)


# We certainly don't want stats on everything that appears in our tables.  We should take a certain percentage of each,
# depending on our needs.  The more we have, the more lookup space to traverse, but less chance of missing a word.

# We will take some percentage of the matches, from the top.
# This should be small since the distribution of matches will fall off quickly.
# We could also experiment with selectiong top-n, or by min. Count.
takeTopPct <- .05;


# NOTE: We actually only need a few of the top unigrams as they are fallback for a
# no-match situation.
MAX<-5000

top_1<-selectTopN(ngram_1, MAX)
top_2<-selectTopN(ngram_2, MAX)
top_3<-selectTopN(ngram_3, MAX)
top_4<-selectTopN(ngram_4, MAX)

top_1mc<-selectMinCount(ngram_1, 2, MAX)
top_2mc<-selectMinCount(ngram_2, 2, MAX)
top_3mc<-selectMinCount(ngram_3, 2, MAX)
top_4mc<-selectMinCount(ngram_4, 2, MAX)


boxplot(ngram_1$Count, ngram_2$Count, ngram_3$Count)
boxplot(top_1$Count, top_2$Count, top_3$Count)
#ngram_2 <- ngrams(allTokens, 2)
#ngram_3 <- ngrams(allTokens, 3)

