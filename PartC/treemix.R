#Alpine Arenosa Subs
setwd("/home/aa/popgenPolypl/TreeMix/")
source("src/plotting_funcs.R")
pdf("chapter/2x4x.pdf", width=14, height=7)
par(mfrow=c(1,2))
plot_tree("chapter/subs_mig0_boot0") 
plot_resid("chapter/subs_mig0_boot0", "poplist.txt")
plot_tree("chapter/subs_mig1_boot0") 
plot_resid("chapter/subs_mig1_boot0", "poplist.txt")
plot_tree("chapter/subs_mig2_boot0") 
plot_resid("chapter/subs_mig2_boot0", "poplist.txt")
plot_tree("chapter/subs_mig3_boot0") 
plot_resid("chapter/subs_mig3_boot0", "poplist.txt")

dev.off()

a<-as.data.frame(seq(0,3,1))
a$ml<-""
a[1,2]<-read.table(paste('chapter/subs_mig0_boot0.llik',sep=""))[2,7]
a[2,2]<-read.table(paste('chapter/subs_mig1_boot0.llik',sep=""))[2,7]
a[3,2]<-read.table(paste('chapter/subs_mig2_boot0.llik',sep=""))[2,7]
a[4,2]<-read.table(paste('chapter/subs_mig3_boot0.llik',sep=""))[2,7]


pdf("chapter/2x4x.likelihood.pdf", width=6, height=6)
plot(a$`seq(0, 3, 1)`,a$ml,ylab = "likelihood",xlab = "no. migrations")
dev.off()


