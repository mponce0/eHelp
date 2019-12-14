# to access the logs from CRAN
library(cranlogs)

# load aux fn
source("ehelpStats-utils.R")

# accept command line arguments
args <- commandArgs(trailingOnly=TRUE)

# some params
t0 <- '2019-10-15'

# retrieve data
# TOTAL
ehelp.stats.total <- cran_downloads("ehelp",from=t0)
# Last Month
ehelp.stats.lstmnt <- cran_downloads("ehelp", when='last-month')

# useful quantities
max.downloads <- max(ehelp.stats.total$count)
max.dwlds.date <- ehelp.stats.total$date[ehelp.stats.total$count == max.downloads]
fst.date <- ehelp.stats.total$date[1]
lst.date <- ehelp.stats.total$date[length(ehelp.stats.total$date)]
tot.days <- length(ehelp.stats.total$date)
mnt.days <- length(ehelp.stats.lstmnt$date)
# bins in weeks
bins <- as.integer(tot.days/7)


### Plots
pdf(file="DWNLDS_ehelp.pdf")
hist(ehelp.stats.total$date,ehelp.stats.total$count,freq=T, breaks=bins)

plot(ehelp.stats.total$date,ehelp.stats.total$count, 'b',
	xlim=c(fst.date,lst.date),
	ylim=c(0,max.downloads*1.05) )
title(main=paste("Total downloads:",sum(ehelp.stats.total$count),'\n',
		"Last month:",sum(ehelp.stats.lstmnt$count)) )

par(new=TRUE)
plot(ehelp.stats.lstmnt$date,ehelp.stats.lstmnt$count, 'b', col='blue', lwd=2,
	ann=FALSE,
	xlim=c(fst.date,lst.date),
	ylim=c(0,max.downloads*1.05) )

# stats from last month
mean.lstmnt <- mean(ehelp.stats.lstmnt$count)
sd.lstmnt <- sd(ehelp.stats.lstmnt$count)
print(paste("Average downloads last month: ",mean.lstmnt,"; sd=",sd.lstmnt))
lines(ehelp.stats.lstmnt$date,rep(mean.lstmnt,mnt.days), type='l', lwd=2, col='blue',
          ann=FALSE,
          xlim=c(fst.date,lst.date),
          ylim=c(0,max.downloads*1.05)
)
text(ehelp.stats.lstmnt$date[2],1.075*mean.lstmnt, paste(as.integer(mean.lstmnt)), col='blue' )

mean.total <- mean(ehelp.stats.total$count)
sd.total <- sd(ehelp.stats.total$count)

abline(h=mean.total, lt=2, col='black')
text(ehelp.stats.total$date[2],1.085*mean.total, paste("avg = ",as.integer(mean.total)) )

# add maximum download
points(max.dwlds.date,max.downloads, col='red', pch=19)
text(max.dwlds.date,max.downloads*1.035,max.downloads, col='red')
dev.off()

### interactive plots
if ( (length(args)>0) & (args[1]=="nointeractive") ) { 
	cat("will skip interactive plots...",'\n')
} else {
	interactivePlots(ehelp.stats.total, mytitle="eHelp Package downloads counts")
	}

# summaries
summaries(ehelp.stats.total,ehelp.stats.lstmnt)
