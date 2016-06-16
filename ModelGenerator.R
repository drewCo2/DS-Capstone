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


# We certainly don't want stats on everything that appears in our tables.  We should take a certain percentage of each,
# depending on our needs.  The more we have, the more lookup space to traverse, but less chance of missing a word.

# We will take 80% of the matches, from the top.
takeTopPct <- .8;

s<-sum(ngram_2$Count)
take<-s*takeTopPct


#ngram_2 <- ngrams(allTokens, 2)
#ngram_3 <- ngrams(allTokens, 3)



TEST<-20
l<-1:100
sel<-selectByMass(l, TEST)
l2<-l[sel]

l2s<-sum(l2)
m<-paste("test ok? ", sum(l2) <= TEST, " :", sum(l2))

message(m)
