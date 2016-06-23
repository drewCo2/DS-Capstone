
# We have nuked the orginal contents of the file so that we can use it to start making predictions / exercising
# our models.


rm(list=ls())
source("begin.R")
source("ModelFuncs.R")
source("PredictionFuncs.R")
source("CreateTestData.R")

# We will get the files ready, and create a model that we can start predicting with...
dir<-'./DataFiles/en_US'
files<-list.files(dir, full.names = TRUE)

textModel<-CreateModel(files, 100, 4, cache.files = TRUE)
textModel2<-CreateModel(files, 500, 4, cache.files = TRUE)


res<-runTests(textModel, testCases)
res<-runTests(textModel2, testCases)

pct<- sum(res$pass) / nrow(res) 
pct

correct<-res[res$pass,]

# head(res,5)



# 
# 
# # This is from one of the quizzes....  I doubt any student project will pass this on its own.
# testLines<-c("The guy in front of me just bought a pound of bacon, a bouquet, and a case of",
#              "You're the reason why I smile everyday. Can you follow me please? It would mean the",
#              "Hey sunshine, can you follow me and make me the",
#              "Very early observations on the Bills game: Offense still struggling but the",
#              "Go on a romantic date at the",
#              "Well I'm pretty sure my granny has some old bagpipes in her garage I'll dust them off and be on my",
#              "Ohhhhh #PointBreak is on tomorrow. Love that film and haven't seen it in quite some",
#              "After the ice bucket challenge Louis will push his long wet hair out of his eyes with his little",
#              "Be grateful for the good times and keep the faith during the",
#              "If this isn't the cutest thing you've ever seen, then you must be")
# 
# test1<-sapply(testLines, function(x) guessWord(textModel, x))
# test1
# 
# 
# # This is our text model, just pared down a bit....
# tm2<-textModel
# for(i in 1:length(tm2))
# {
#   tm2[[i]]<-head(tm2[[i]], 5000)
# }
# 
# 
# st<-proc.time()
# guessWord(textModel, "The guy in front of me just bought a pound of bacon, a bouquet, and a case of")
# et<-proc.time()
# et-st
# 
# st<-proc.time()
# guessWord(tm2, "The guy in front of me just bought a pound of bacon, a bouquet, and a case of")
# et<-proc.time()
# et-st
# 
# 
# q2qs<-c("When you breathe, I want to be the air for you. Ill be there for you, Id live and Id",
#         "Guy at my table's wife got up to go to the bathroom and I asked about dessert and he started telling me about his",
#         "I'd give anything to see arctic monkeys this",
#         "Talking to your mom has the same effect as a hug and helps reduce your",
#         "When you were in Holland you were like 1 inch away from me but you hadn't time to take a",
#         "I'd just like all of these questions answered, a presentation of evidence, and a jury to settle the",
#         "I can't deal with unsymetrical things. I can't even hold an uneven number of bags of groceries in each",
#         "Every inch of you is perfect from the bottom to the",
#         "I’m thankful my childhood was filled with imagination and bruises from playing",
#         "I like how the same people are in almost all of Adam Sandler's")
# 
# 
# sapply(q2qs, function(x) guessWord(textModel, x))
# 
# object.size(tm2)
# 
# saveRDS(textModel, "textModel-1.RDS")
# object.size(textModel)
# 
# 
# saveRDS(tm2, "./Shiny/tm2.rds")
# 
# textModel<-readRDS("textModel-1.RDS")
# 














