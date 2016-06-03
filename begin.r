# Let's get the data we will need if we don't already have it.
srcPath<-"SwiftKeyData.zip"

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
  