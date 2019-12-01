
### interactive plots
interactivePlots <- function(downloads.data, mytitle="eHelp Package downloads counts",
				nbrPlts = 2,
				HTMLfile="InteractiveDWNDstats.html") {
        
        library(plotly)

	tot.days <- length(downloads.data[,1])

        p1 <- plot_ly(data = downloads.data, x = ~date, y = ~count,
		mode="lines+markers", fill = 'tozeroy',
                marker = list(size = ~count,
			color = ~count, text = paste("downloads: ",~count),
			line = list(color = 'rgba(152, 0, 0, .8)', width = 2))) %>%
		add_annotations(
                        x=0.15,y=1.00, xref="paper",yref="paper",
                        text = paste("Downloads in the last month: ",'<b>',sum(downloads.data$count[(tot.days-31):tot.days]),'</b>'), showarrow = F ) %>%
		add_annotations(
			x=0.15,y=0.950, xref="paper",yref="paper",
			text = paste("Total downloads: ",'<b>',sum(downloads.data$count),'</b>'), showarrow = F ) %>%
		add_annotations(
			x=0.15,y=0.975, xref="paper",yref="paper",
			text = paste("Avg dwnlds: ",'<b>',mean(downloads.data$count[(tot.days-31):tot.days]),'</b>'), showarrow = F ) %>%
		add_annotations(
			x=0.15,y=0.925, xref="paper",yref="paper",
			text = paste("Avg per day: ",'<b>',mean(downloads.data$count),'</b>'), showarrow = F ) %>%
          layout(title = mytitle,
                 yaxis = list(zeroline = TRUE),
                 xaxis = list(zeroline = TRUE))
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
	print(summary(data1))
	print(summary(data2))
}
