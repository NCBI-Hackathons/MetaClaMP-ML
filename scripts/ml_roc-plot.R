#command: Rscript rocplot.R roc_output.pdf
#edit path
#the input file names should be df1.tsv df2.tsv ...... df9.tsv or change line 9 below according to file names

args = commandArgs(trailingOnly=TRUE)
library(tidyverse);library(data.table);library(pROC);library(ROCR);library(viridis);library("optparse");library("textreadr")
#==#
#path="/Users/kumardeep/Downloads/softwares/github/EnviroGenes_playground" #CAUTION: change path here
#--#

files <- list.files(path = '.', pattern = "ml_actual_predictions.txt", full.names = T) #file from the svm-sklearn output



color=viridis(3)
legendwa<-c()

#pdf('~/Downloads/zz.pdf',width=5,height = 5)
#pdf('/Users/kumardeep/Downloads/softwares/github/EnviroGenes_playground',width=5,height = 5)
pdf('roc.pdf',width=5,height = 5)
for (i in 1:length(files)){
	#print(dim(list[[1]]))
	#dfx=list[[i]]
	#pred.nn <- prediction(dfx$predictions,dfx$labels)
	dfx=read_tsv(files[i],col_names = F)
	pred.nn <- prediction(dfx$X2,dfx$X1)
	perf.nn <- performance(pred.nn,'tpr','fpr')
	perf.nn <- performance(pred.nn,'tpr','fpr',spread.scale=2)
	#plot(perf.nn, col="blue")
	if(i>1){
		plot(perf.nn, col=color[i],add=T,colorize=TRUE)
	}else{
		plot(perf.nn, col=color[i],colorize=TRUE)
	}
	lv=paste0('AUC: ', signif(ci.auc(dfx$X1,dfx$X2)[3],2),' (',signif(ci.auc(dfx$X1,dfx$X2)[3],1),'-',signif(ci.auc(dfx$X1,dfx$X2)[3],2),')')
	legendwa<-c(legendwa,lv)
}
legend("bottomright", legend=legendwa, col=color, lwd=2)
abline(a=0, b=1)
dev.off()
