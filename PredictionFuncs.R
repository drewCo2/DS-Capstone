
library(quanteda)
library(dplyr)

# Create a string that we can use with dplyr's 'filter_' function.
# We use this to select our ngrams from the result sets.
makeFilter<-function(tokens)
{
  n<-length(tokens)
  res<-sapply(1:n, function(x)
  {
    sprintf("t%d=='%s'",x, tokens[x])  
  })
  
  res<-paste(res, collapse=" & ")
  res
}

# split the input into individual words.
getTokens<-function(input)
{
  # NOTE: R sucks at regex.  Also, we could create something that is a bit more sophiticated, I guess.
  # We aren't dumping numbers for example, but I guess we could...
  # We could also split along sentence lines, i.e. anything with a period in it.
  input<-gsub("[[:punct:]]", " ", input)
  res<-unlist(lapply(strsplit(input, split=" "), function(x){x[!x ==""]}))
  res
}

# return up to the last n-tokens from the stream.
getLastTokens<-function(tokens, n)
{
  len<-length(tokens)
  if (len <= n)
  {
    tokens
  }
  else
  {
    start = (len-n)+1
    res<-tokens[start:len]
    res
  }
}


# this will get the groups of the best matches along the different token lengths.
getMatchGroups<-function(tokens, n, df)
{
  if(n == 0)
  {
    match<-head(df,1)
  }
  else
  {
    # we actually need a better windowing function here.  Getting the last few doesn't really make sense.
    t<-getLastTokens(tokens, n)
    filter<-makeFilter(t)
    match<-filter_(df, .dots=filter)
  }
  
  if(nrow(match) > 0)
  {
    # Take the top listed item. assuming this is our best guess.
    # later we could determine tie breakers by looking at our distributions of unigrams.
    best <- head(match, 1)
    nc<-ncol(best)
    res<-data.frame(token=best[1,nc-1], p=best[1,nc], stringsAsFactors = FALSE)
    res
  }
  else
  {
    res<-data.frame(token="", p=0, stringsAsFactors = FALSE)
    res
  }
  
}

guessWord<-function(model, input)
{
  srcTokens<-getTokens(input)
  
  # this will be the function.....
  # determine the max number of tokens that we can predict on...
  maxPredict<- min(length(srcTokens), length(model) - 1)
  
  
  useLens<-maxPredict:0
  allMatches<-lapply(useLens, function(x) getMatchGroups(srcTokens, x, model[[x+1]]))
  
  # Now that we have all of the matches, we can just cyle through till we get our max...  res<-""
  for (i in 1:length(allMatches)) {
    # We just return the very first match.  This approach favors the larger n-grams that
    # have a hit.  We don't take the p value into account at all.
    m<-allMatches[[i]][1,1]
    if(m != "")
    {
      res<-m
      break
    }
  }
  
  res
}

