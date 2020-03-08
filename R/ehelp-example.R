eexample <- function(..., skip.donts=FALSE) {
# will use ellipsis '...' to adquire the function's name
#
#' function that allows to execute the examples from user defined functions
#'
#' @param  ...  function name of a user defined fn
#' @param  skip.donts  boolean argument to specify whether dontest or dontrun examples should be skiped or not
#'
#' @export
#'

	# check that there is only one argument
	if (length(list(...)) != 1) stop("Please indicate the name of a function to run its examples.")
	#print(eval(parse(text=...)))

	# process fn
	ehelp.output <- capture.output(ehelp(...))

	fnName <- as.character(substitute(...))

	# print(ehelp.output)

	# define some stopping "coddons" based on ehelp output
	ex.header <- "### Examples: "
	next.topic <- "###"

	# define don'tS run/test...
	donts <- c("\\donttest","\\dontrun","\\dontshow")
	ending <- "}"
	donts.activated <- FALSE
	
	# check whether there is an example section
	if (ex.header %in% ehelp.output) {
		example.line <- which(grepl(ex.header, ehelp.output))

		tot.lines <- length(ehelp.output)

		examples.run <- 0

		if (tot.lines > 1)
			cat("#####  Running examples from fn ",fnName," #####",'\n')

		next.line <- example.line + 1
		while (next.line <= tot.lines & is.na(pmatch(next.topic,ehelp.output[next.line])) ) {
			#cat(next.line, ' -- ', ehelp.output[next.line], '\n')
			# remove leading spaces to compare against stopping "coddons"
			target.line <- sub("^\\s+", "", ehelp.output[next.line])

			# check against donts...  AND   stopping "coddons"...
			if ( sum(is.na(pmatch(donts,target.line)))==length(donts)  &
				!(donts.activated & !is.na(pmatch(ending,target.line))) )  {
				if ( !donts.activated | !skip.donts) {
					# cat(donts.activated, " -- ",target.line,'\n')
					cat(paste0(fnName,">> "), ehelp.output[next.line], '\n')
					X <- eval(parse(text=ehelp.output[next.line]))
					if (!is.null(X)) print(X)
					if (nchar(trimws(target.line)) > 0) examples.run <- examples.run + 1
				}
			} else {
				donts.activated <- TRUE
			}

			next.line <- next.line + 1
		}

		cat("#####  Number of commands ran from the examples ",fnName,": ",examples.run,"   #####",'\n')
		if (examples.run == 0 & skip.donts) {
			cat("#####  Note: skipping ",paste(donts,collapse='-')," examples, you can run these by setting skip.donts=FALSE",'\n')
		}# else if (examples.run == 0) {
		#	cat("##### No examples found in ",fnName,'\n')
		#}
	} else {
		cat("##### No examples found in ",fnName,'\n')
	}
}
