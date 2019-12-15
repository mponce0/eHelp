# to access the logs from CRAN
library(cranlogs)

# load aux fn
source("ehelpStats-utils.R")

# accept command line arguments
# possible values: nostatic, nointeractive, nocombined
# defaults are to generate static & interactive plots, and combined static plots
args <- commandArgs(trailingOnly=TRUE)

# some params
t0 <- '2019-10-15'

# retrieve data
# TOTAL
ehelp.stats.total <- cran_downloads("ehelp",from=t0)
# Last Month
ehelp.stats.lstmnt <- cran_downloads("ehelp", when='last-month')


### Plots
if ('nostatic' %in% tolower(args)) {
	message("Will skip static plots...")
} else {
	if ('nocombined' %in% tolower(args)) {
		cmb <- FALSE
	} else {
		cmb <- TRUE
	}
	staticPlots(ehelp.stats.total,ehelp.stats.lstmnt, combinePlts=cmb)
	}

### interactive plots
if ( "nointeractive" %in% tolower(args) ) { 
	message("will skip interactive plots...")
} else {
	interactivePlots(ehelp.stats.total, mytitle="eHelp Package downloads counts")
	}

# summaries
summaries(ehelp.stats.total,ehelp.stats.lstmnt)
