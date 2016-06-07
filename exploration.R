rm(list=ls())

source("begin.r")



# The source files are very large.  I think that trying to compute / sample their entire
# contents would be a bad idea.  Using our inference skills however, we should be able to take
# a random sampling of lines + infer some statistics from that.


names<-c('Blogs','News','Twits')
paths=c(usBlogs,usNews,usTwits)
m<-data.frame(Names=names, Paths=paths)

# we will read in all of the lines so that we can sample from them.
lines<-sapply(paths, readAllLines, USE.NAMES=FALSE)

# Now we can do the sampling...
# Seed / Samples / lines per file.
set.seed(123)
sampleCount<-1000


sampleSet<-sapply(lines, function(x) sample(x, sampleCount), USE.NAMES = FALSE)
sampledLines<-c(sampleSet[,1], sampleSet[,2],sampleSet[,3])

# Now we have all of the sampled lines squished together, so we can start performing some analysis on them.
c<-corpus(sampledLines)
summary(c)

docStats<-dfm(c)

# rm(lines)

c<corpus(sampleSet[[1]])
# Let's explore the data a bit, shall we?
# library(tm)




# We want to create a corpus so that we can create a document term matrix.
# This part of the process will take a while to run.

# ds<-DirSource(usDir, recursive=FALSE)
# corpus<-VCorpus(ds)
# tdm<-TermDocumentMatrix(corpus)
