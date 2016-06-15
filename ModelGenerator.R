# This file creates our prediction 'model' for the n-gram analyzer.
# We are going to do some sampling / training, and create a type of table that we will use to make
# predictions.

# A lot of this content was taken from the exploration and assignment files.

rm(list=ls())
source("begin.r")

# defs
COLS<-2


# The files that we will need...
dir<-'./DataFiles/en_US'
files<-list.files(dir, full.names = TRUE)


# We will define + apply a function that will be used to extract all of the lines form our files.
# We will use these lines for subsequent processing.
readAllLines<-function(path)
{
  c<-file(path, open="rt")
  lines<-readLines(c)
  close(c)
  
  lines
}

# This will take all lines, squash them to a single vector, and tokenize them.
# getTokens<-function(lines)
# {
#   doc<-paste(lines, collapse = " ")
#   
#   # Note the removal of punctuation, numbers, etc. from the list of tokens.
#   t<-tokenize(doc, removeNumbers=TRUE, removePunct=TRUE, removeTwitter=TRUE, simplify=TRUE)
#   t
# }

# squish all of the lines into a single (all lowercase) 'document'
createDoc<-function(lines)
{
  doc<-sapply(lines, MARGIN=COLS, paste, collapse=" ")
  doc<-toLower(paste(doc, collapse=" "))
  doc
  # collapse our matrix into a single document composed of our sampled data.
  # once we have the docs together, we can tokenize!
#   docs<-apply(sampleSet, MARGIN=COLS, function(x) paste(x, collapse = " "))
#   docs<-toLower(paste(docs, collapse=" "))
  
}

# We can read all of the lines in for processing.
lineGroups <- sapply(files, readAllLines)


# Now we can do the sampling...
# Seed / Sample lines per file.
set.seed(1234)
sampleSize<-1000
sampleSet<- sapply(lineGroups, function(x) sample(x, sampleSize))

# squish all of the lines into some docs that we can tokenize with.
docSet<-apply(sampleSet, MARGIN = COLS, createDoc)


