### static plots
staticPlots <- function(pckg.stats.total,pckg.stats.lstmnt,
			fileName="DWNLDS_ehelp.pdf", combinePlts=FALSE){

	# informing where the plot is going to be saved
	message("Saving static plots in ",fileName)

	# useful quantities
	max.downloads <- max(pckg.stats.total$count)
	max.dwlds.date <- pckg.stats.total$date[pckg.stats.total$count == max.downloads]
	fst.date <- pckg.stats.total$date[1]
	lst.date <- pckg.stats.total$date[length(pckg.stats.total$date)]
	tot.days <- length(pckg.stats.total$date)
	mnt.days <- length(pckg.stats.lstmnt$date)

	# open PDF file
	pdf(fileName)

	if (combinePlts) {
		par(new=TRUE)
		par(mfrow=c(3,3))
	}
        ### histogram
        # bins in units of weeks
        bins <- as.integer(tot.days/7)

        hist(pckg.stats.total$date,pckg.stats.total$count,freq=T, breaks=bins, col='gray')
	#title("Downloads histogram")

	# reset canvas to 1 plt per page
	par(mfrow=c(1,1))
	if (combinePlts) par(new=TRUE)

	### plotting downloads per day
	plot(pckg.stats.total$date,pckg.stats.total$count, 'b',
		xlim=c(fst.date,lst.date),
		ylim=c(0,max.downloads*1.05) ,
		ann=FALSE, axes=FALSE )

	# print some stats in the plot
	title(main=paste("Total downloads:",sum(pckg.stats.total$count),'\n',
		"Last month:",sum(pckg.stats.lstmnt$count)) )

	# emphasize last month data
	par(new=TRUE)
	plot(pckg.stats.lstmnt$date,pckg.stats.lstmnt$count,
		'b', col='blue', lwd=2,
		ann=FALSE, axes=FALSE,
		xlim=c(fst.date,lst.date),
		ylim=c(0,max.downloads*1.05) )


	# stats from last month
	mean.lstmnt <- mean(pckg.stats.lstmnt$count)
	sd.lstmnt <- sd(pckg.stats.lstmnt$count)
	message(paste("Average downloads last month: ",mean.lstmnt,"; sd=",sd.lstmnt))
	lines(pckg.stats.lstmnt$date,rep(mean.lstmnt,mnt.days), type='l', lwd=2, col='blue',
		ann=FALSE,
		xlim=c(fst.date,lst.date),
		ylim=c(0,max.downloads*1.05) )
	text(pckg.stats.lstmnt$date[2],1.075*mean.lstmnt, paste(as.integer(mean.lstmnt)), col='blue' )


#        if (combinePlts) {
                axis(side=1,
			at=pckg.stats.total$date[seq_along(pckg.stats.total$date)%%6==0],
			labels=as.character.Date(pckg.stats.total$date[seq_along(pckg.stats.total$date)%%6==0], "%d-%m-%y")
		)
                axis(side=4)
#        } else {
#                axis(side=c(1:4))
#        }


	mean.total <- mean(pckg.stats.total$count)
	sd.total <- sd(pckg.stats.total$count)

	abline(h=mean.total, lt=2, col='black')
	text(pckg.stats.total$date[2],1.085*mean.total, paste("avg = ",as.integer(mean.total)) )

	# add maximum download
	points(max.dwlds.date,max.downloads, col='red', pch=19)
	text(max.dwlds.date,max.downloads*1.035,max.downloads, col='red')


	# Close file
	dev.off()
}



### interactive plots
interactivePlots <- function(downloads.data, mytitle="eHelp Package downloads counts",
				nbrPlts = 2, month.ln=31,
				HTMLfile="InteractiveDWNDstats.html") {
        
        if (require(plotly) == FALSE)
		stop("plotly not present!")

	tot.days <- length(downloads.data[,1])

	if (tot.days > month.ln) {
		mnth.rng <- (tot.days-month.ln):tot.days
		lst.mnth <- downloads.data[mnth.rng,]
	} else {
		lst.mnth <- downloads.data
		mnth.rng <- 1:tot.days
		month.ln <- tot.days
	}

        p1 <- plot_ly() %>%
		add_trace(data = downloads.data, x = ~date, y = ~count,
		mode="lines", fill = 'tozeroy', alpha=0.25, name="dwnlds",
                marker = list(size = ~count,
			color = ~count, text = paste("downloads: ",~count), 
			line = list(color = 'rgba(152, 0, 0, .8)', width = 2))) %>%
		add_trace(x =~date[mnth.rng], y = ~count[mnth.rng], mode="lines+markers", name="LMD", line=list(width=3.5), fill='tozeroy') %>%
		#add_ribbons(x = lst.mnth$date, ymin = lst.mnth$count*0.95, ymax = lst.mnth$count*1.05, color = I("gray95"), name = "last month") %>%
		add_annotations(
                        x=0.15,y=1.00, xref="paper",yref="paper",
                        text = paste("Downloads in the last month: ",'<b>',sum(lst.mnth$count),'</b>'), showarrow = F ) %>%
		add_annotations(
			x=0.15,y=0.950, xref="paper",yref="paper",
			text = paste("Total downloads: ",'<b>',sum(downloads.data$count),'</b>'), showarrow = F ) %>%
		add_annotations(
			x=0.15,y=0.975, xref="paper",yref="paper",
			text = paste("Avg dwnlds: ",'<b>',round(mean(lst.mnth$count),digits=2),'</b>'), showarrow = F ) %>%
		add_annotations(
			x=0.15,y=0.925, xref="paper",yref="paper",
			text = paste("Avg per day: ",'<b>',round(mean(downloads.data$count),digits=2),'</b>'), showarrow = F ) %>%
          layout(title = mytitle,
                 xaxis = list(zeroline = TRUE), #range=c(downloads.data$date[1],downloads.data$date[tot.days])),
                 yaxis = list(zeroline = TRUE))
        print(p1)

	if (nbrPlts == 2) {
		p2 <- plot_ly(data = downloads.data, x = ~date) %>% 
			#add_histogram(y = ~count) %>%
			add_trace(y = ~count, color = ~count, size=~count,
				mode="markers+line", fill="tozeroy",
#				text = paste("downloads: ",~count)
#				 ) %>%
					marker=list(colorscale="Blues",reversescale=TRUE) ) %>%
			add_trace(y = ~count, color=~count, mode = 'lines', fill = 'tozeroy')     %>%
			layout(title = mytitle,
				yaxis = list(zeroline = TRUE),
				xaxis = list(range = c(downloads.data$date[1],downloads.data$date[length(downloads.data$date)])) )
#				colorscale="Blues", showscale = FALSE, showlegend = TRUE)
			print(p2)

	p <- subplot(p1,p2)
	} else {
		p <- p1
		}

	htmlwidgets::saveWidget(as_widget(p), HTMLfile)

	return(p)
}


# summaries
summaries <- function(data1,data2) {
	print(paste("period: ",data1$date[1],' - ',data1$date[length(data1$date)]))
	print(summary(data1))
	print(paste("period: ",data1$date[1],' - ',data1$date[length(data1$date)]))
	print(summary(data2))
}
