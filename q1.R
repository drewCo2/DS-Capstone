rm(list=ls())

wd<-getwd()
usDir<-paste0(wd,"/Repos/DS-Capstone/DataFiles/en_US")

#q1.
q1a<-'200mb'


#q2
path<-paste0(usDir, '/en_US.twitter.txt')
c<-file(path, open="rt")

twitData<-readLines(c)

# this is how many lines (rows)
q2a<-length(twitData)

close(c)
# data<-read.csv(path)


#q3

#given a path, we will find the longest line in the file.
getMaxLineLen<-function(path)
{
  c<-file(path, open="rt")
  
  lines<-readLines(c)
  lens<-sapply(lines, nchar, USE.NAMES=FALSE)
  
  res<-max(lens)
  
  # always close your connections!
  close(c)
  
  res
  
}

# we are counting the longest line in all of the files.
allPaths<- sapply(list.files(path=usDir), function(x) paste0(usDir,'/', x))
allMax<-sapply(allPaths, getMaxLineLen)

# The files go in order.
q3a<-max(allMax)  # BLOGS



#q4
# In the en_US twitter data set, if you divide the number of lines where the word "love" (all lowercase) occurs by the number of lines the word "hate" (all lowercase) occurs, about what do you get?

# loveLines<-
# a way to count lines that have matching patterns from file data.
getMatchCount<-function(pat, lines)
{
  hasMatch<-sapply(lines, function(x) grepl(pat, x), USE.NAMES = FALSE)
  res<-sum(hasMatch)
  res
  #
}

loveCount = getMatchCount('love', twitData)
hateCount= getMatchCount('hate', twitData)

q4a<- loveCount / hateCount
q4a


#q5

# we know that there is only one matching line it would seem.
sel = sapply(twitData, function(x) grepl('biostats', x), USE.NAMES = FALSE)
match<-twitData[sel]
q5a<-match

#q6

phrase<-"A computer once beat me at chess, but it was no match for me at kickboxing"
match<-getMatchCount(phrase, twitData)

q6a<-match
