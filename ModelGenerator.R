# This file creates our prediction 'model' for the n-gram analyzer.
# We are going to do some sampling / training, and create a type of table that we will use to make
# predictions.

# A lot of this content was taken from the exploration and assignment files.

# NOTE: This file was mostly used for exploratory purposes, and is now obsolete.....

rm(list=ls())

source("begin.R")
source("ModelFuncs.R")
source("PredictionFuncs.R")

library(quanteda)
library(dplyr)



# The files that we will need...
dir<-'./DataFiles/en_US'
files<-list.files(dir, full.names = TRUE)


# We can read all of the lines in for processing.
lineGroups <- sapply(files, readAllLines)

# defs
COLS<-2


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


parts<-list(ngram_1, ngram_2, ngram_3, ngram_4)
model<-sapply(1:length(parts), function(x) makeNgDf(parts[[x]], x))



x<-makeNgDf(ngram_2, 2)
sel<-(x$t1=="of" & x$t2 == "the")
x[sel,]


y<-makeNgDf(ngram_3, 3)



ti<-getTokens("This is a bit of data")

fil<-makeFilter(ti) 
fil

# Note.  If this doesn't match, we will have to backtrack....

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




dir<-'./DataFiles/en_US'
files<-list.files(dir, full.names = TRUE)

textModel<-CreateModel(files, 500, 4, cache.files = TRUE)

st<-proc.time()
guessWord(textModel, "the reason there is a")

guessTime<-proc.time()-st
guessTime

