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


### Plots
staticPlots(ehelp.stats.total,ehelp.stats.lstmnt, combinePlts=TRUE)

### interactive plots
if ( (length(args)>0) & (args[1]=="nointeractive") ) { 
	cat("will skip interactive plots...",'\n')
} else {
	interactivePlots(ehelp.stats.total, mytitle="eHelp Package downloads counts")
	}

# summaries
summaries(ehelp.stats.total,ehelp.stats.lstmnt)
