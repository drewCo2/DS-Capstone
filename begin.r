# Let's get the data we will need if we don't already have it.
srcPath<-"SwiftKeyData.zip"

library(quanteda)


if (!file.exists(srcPath))
{
  srcUrl<-'https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip'
  download.file(srcUrl, srcPath, method='curl')
}

# Once we have the content of the file, we can go ahead and unzip it for analysis later.
finalDir<-"DataFiles"
if (!dir.exists(finalDir))
{
  message("unzipping the data contents.")
  unzip(srcPath)
  file.rename("final", finalDir)
}
  

# We should setup all of our paths that may be of use while we are at it.
wd<-getwd()
dataDir<-paste0(wd, "/DataFiles/")

usDir<-paste0(dataDir,"en_US")

# do we need others?
usTwits<-paste0(usDir,"/","en_US.twitter.txt")
usNews<-paste0(usDir,"/","en_US.news.txt")
usBlogs<-paste0(usDir,"/","en_US.blogs.txt")


# Read and return all lines from a file.
readAllLines<-function(path)
{
  c<-file(path, open="rt")
  lines<-readLines(c)
  close(c)
  
  lines
}

