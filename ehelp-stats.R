# to access the logs from CRAN
library(cranlogs)

# some params
t0 <- '2019-10-15'

# retrieve data
# TOTAL
ehelp.stats.total <- cran_downloads("ehelp",from=t0)
# Last Month
ehelp.stats.lstmnt <- cran_downloads("ehelp", when='last-month')

# useful quantities
max.downloads <- max(ehelp.stats.total$count)
fst.date <- ehelp.stats.total$date[1]
lst.date <- ehelp.stats.total$date[length(ehelp.stats.total$date)]
tot.days <- length(ehelp.stats.total$date)
mnt.days <- length(ehelp.stats.lstmnt$date)
# bins in weeks
bins <- as.integer(tot.days/7)

### Plots
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
print(paste("Avergge downloads last month: ",mean.lstmnt))
lines(ehelp.stats.lstmnt$date,rep(mean.lstmnt,mnt.days), type='l', lwd=2, col='blue',
          ann=FALSE,
          xlim=c(fst.date,lst.date),
          ylim=c(0,max.downloads*1.05)
)
text(ehelp.stats.lstmnt$date[2],1.05*mean.lstmnt, paste(as.integer(mean.lstmnt)), col='blue' )

mean.total <- mean(ehelp.stats.total$count)

abline(h=mean.total, lt=2, col='black')
text(ehelp.stats.total$date[2],1.05*mean.total, paste("avg = ",as.integer(mean.total)) )

# summaries
print(summary(ehelp.stats.total))
print(summary(ehelp.stats.lstmnt))
