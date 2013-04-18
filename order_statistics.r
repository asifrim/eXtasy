library(RobustRankAggreg)
args <- commandArgs(trailingOnly = TRUE)

d <- read.table(args[1], header=TRUE, sep="\t")
glist <- list()

for(i in names(d)[6:dim(d)[2]]){
	glist[[i]] <- as.character(d[order(d[,i],decreasing=TRUE),"variant_id"])
}

res <- aggregateRanks(glist, method="stuart")

write.table(res, file=paste(args[1],".order_statistics_output",sep=""), sep="\t", quote=FALSE, row.names=FALSE)




