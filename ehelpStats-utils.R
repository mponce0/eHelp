
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
