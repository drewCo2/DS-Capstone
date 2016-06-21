
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


# x<-getTokens("this is a cow that I milked.")
# y<-getLastNTokens(x, 3)
# y

# TEMP:
parts<-list(ngram_1, ngram_2, ngram_3, ngram_4)
model<-sapply(1:length(parts), function(x) makeNgDf(parts[[x]], x))

input<-"into the void"
srcTokens<-getTokens(input)

# this will be the function.....
# determine the max number of tokens that we can predict on...
maxPredict<- length(model) - 1

# this will get the groups of the best matches along the different token lengths.
getMatchGroups<-function(tokens, n, df)
{
  # we actually need a better windowing function here.  Getting the last few doesn't really make sense.
  t<-getLastTokens(tokens, n)
  filter<-makeFilter(t)
  match<-filter_(df, .dots=filter)
  match
}

useLens<-2:maxPredict


# usedf<-model[[curSize]]
# srcTokens<-getTokens(input)
# t<-getLastTokens(srcTokens, curSize)
# # t
# 
# filter<-makeFilter(t)
# match<-filter_(usedf, .dots=filter)

# matchOK<-true
# if(length(match) > 0)
# {
#   # W  
# }
# else
# {
#   matchOK<-false
# }




guessWord<-function(model, input)
{
}

