
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
ngramDF<-function(tokens, n)
{
  ng<-ngrams(tokens, n, concatenator = " ")
  t<-table(ng)
  df<-data.frame(t)
  names(df)<-c('Term', 'Count')
  
  df<-arrange(df, desc(Count), Term)
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
  res<-data.frame(t(mat)) 
  names(res)<-cNames
  
  # we want to arrange these to t(1...n-1) -> count -> t(n)
  # ths orders the table so that we have the most likely token given the preceding n-1 tokens.
  order<-c(cNames[1:gramSize-1], "desc(p)", cNames[gramSize+1])
  res<-arrange_(res, .dots=order) 
  res
}

# Create a logical vector based on a given mass.  The (numeric) vector in question will be progressively summed
# and any current sum that is <= mass will return TRUE.  Works great in sorted lists.
accIsLessThanMass<-function(vec, mass)
{
  acc<-0
  
  res<-sapply(vec, function(x) {
    acc<<-acc+x
    acc <= mass
  })
  res
}

# Just grab the top terms from the df, according to our count percents.
selectTopPct<-function(df, pct)
{
  s<-sum(df$Count)
  mass<-s*pct
  
  sel<-accIsLessThanMass(df$Count, mass)
  res<-df[sel,]
  res
  
}

# Grab the top n-items from the df
selectTopN<-function(df, n)
{
  res<-df[1:n, ]
  res
}

# select the top-n items that have a count >= min.
# limited by maxN
selectMinCount<-function(df, min, maxN)
{
  sel<-df$Count >= min
  res<-df[sel,]
  if (nrow(res) > maxN)
  {
    res<-res[1:maxN,]
  }
  res
}
