
source("PredictionFuncs.R")

library(quanteda)
library(dplyr)

# We will define + apply a function that will be used to extract all of the lines form our files.
# We will use these lines for subsequent processing.
readAllLines<-function(path)
{
  c<-file(path, open="rt")
  lines<-readLines(c)
  close(c)
  
  lines
}

# squish all of the lines into a single (all lowercase) 'document'
createDoc<-function(lines)
{
  doc<-sapply(lines, paste, collapse=" ", USE.NAMES=FALSE)
  doc<-toLower(paste(doc, collapse=" "))
  doc
}

# Create a data frame that contains the terms (ngram) and associated count.
ngramDF<-function(tokens, n, minN, maxRows)
{
  ng<-ngrams(tokens, n, concatenator = " ")
  t<-table(ng)
  df<-data.frame(t)
  names(df)<-c('Term', 'p')
  
  # randomize the names....  This is so we can accurately truncate the size of our list.
  df<-df[sample(nrow(df)),]
  df<-arrange(df, desc(p))
  
  df<-df[df$p > (minN-1),]
  df<-head(df, maxRows)
  
  df<-mutate(df, Term=as.character(Term))
  df
}


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
  mat<-apply(ngrams, MARGIN=1, splitRow)
  
  # note that we are transposing our matrix.
  res<-data.frame(t(mat), stringsAsFactors = FALSE)
  names(res)<-cNames
  res[,ncol(res)] = as.numeric(res[,ncol(res)])
  
  # we want to arrange these to t(1...n-1) -> count -> t(n)
  # ths orders the table so that we have the most likely token given the preceding n-1 tokens.
  order<-c(cNames[1:gramSize-1], "desc(p)", cNames[gramSize+1])
  res<-arrange_(res, .dots=order) 
  res
}


getSampleSet<-function(files, sampleSize, cache.files=FALSE)
{

  # We can read all of the lines in for processing.
  reload<-TRUE
  if (cache.files)
  {
    reload<-!exists("lineGroups")
    if (!reload) { message("Using cached files.") }
  }
  if (reload)
  {
    message("Reading source files...")
    lineGroups <<- sapply(files, readAllLines)
  }
  
  # Now we can do the sampling...
  # Seed / Sample lines per file.
  message("Creating sample sets...")
  sampleSet<- sapply(lineGroups, function(x) sample(x, sampleSize))

  sampleSet
}


# Create a prediction model based on the given files + parameters.
# files = vector of file paths that contain the data we will sample from.
# sampleSize = The number of samples to take from each file.
# maxnGrams = The max number of ngram lookups that will be built.
# minN = The minimum number of matches that an ngram set must have to be included in the model.
# maxRows = the max number or rows that will be places in the model, per ngram group.
CreateModel<-function(files, sampleSize, maxnGrams, minN=2, maxRows=5000, cache.files=FALSE)
{
  
#   # We can read all of the lines in for processing.
#   reload<-TRUE
#   if (cache.files)
#   {
#     reload<-!exists("lineGroups")
#     if (!reload) { message("Using cached files.") }
#   }
#   if (reload)
#   {
#     message("Reading source files...")
#     lineGroups <<- sapply(files, readAllLines)
#   }
# 
#   # Now we can do the sampling...
#   # Seed / Sample lines per file.
#   message("Creating sample sets...")
#   sampleSet<- sapply(lineGroups, function(x) sample(x, sampleSize))
  
  sampleSet<-getSampleSet(files, sampleSize, cache.files)
  
  message("Creating docs...")
  docSets<-apply(sampleSet, MARGIN=2, createDoc)
  
  message("tokenizing docs...")
  allTokens<-tokenize(paste(docSets, collapse=" "), removeNumbers=TRUE, removeHyphens = TRUE, removePunct=TRUE, removeTwitter=TRUE, simplify=TRUE)
  
  message("computing ngrams...")
  parts <- lapply(1:maxnGrams, function(x) ngramDF(allTokens, x, minN, maxRows))
  
  message("finalizing model")
  model<-sapply(1:length(parts), function(x) makeNgDf(parts[[x]], x))
  model
  
}

# 
# s<-"this is a doc that I made from scratch for some testing!  It is a good doc and I think I will keep it!"
# t<-tokenize(s, removeNumbers=TRUE, removeHyphens = TRUE, removePunct=TRUE, removeTwitter=TRUE, simplify=TRUE)
# tb<-table(t)
# 
# df<-data.frame(tb)
# names(df)<-c('Term', 'p')
# 
# # now we can compute the p-values.
# df$p = df$p / sum(df$p)
