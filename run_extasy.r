library(randomForest)
args <- commandArgs(trailingOnly = TRUE)
load(args[2]) #loads rf
load(args[3]) #loads rfhaplo


d <- read.table(args[1], header=TRUE, sep="\t")
pcomplete <- predict(rf, d, type="prob")
pincomplete <- predict(rfhaplo, na.roughfix(d), type="prob" )

d$extasy_complete = pcomplete[,2]
d$extasy_imputed = pincomplete[,2]
write.table(d, file=paste(args[1],".extasy_output",sep=""), sep="\t", quote=FALSE, row.names=FALSE)


