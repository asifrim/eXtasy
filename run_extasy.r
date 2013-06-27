library(randomForest)
args <- commandArgs(trailingOnly = TRUE)
load(args[2]) #loads rf
load(args[3]) #loads rfhaplo


d <- read.table(args[1], header=TRUE, sep="\t")
if(class(d$altbase) != "factor"){
	d[d$altbase == TRUE,]$altbase = "T"
	d$altbase <- as.factor(d$altbase)
}
if(class(d$refbase) != "factor"){
	d[d$refbase == TRUE,]$refbase = "T"
	d$refbase <- as.factor(d$refbase)
}

pcomplete <- predict(rf, d, type="prob")
pincomplete <- predict(rfhaplo, na.roughfix(d), type="prob" )

d$extasy_complete = pcomplete[,2]
d$extasy_imputed = pincomplete[,2]
write.table(d, file=paste(args[1],".extasy_output",sep=""), sep="\t", quote=FALSE, row.names=FALSE)


