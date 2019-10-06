# eHelp.R
#  -- M.Ponce

# Enhanced-Help Function: ehelp()
# enhanced help function, capable of extracting "a-la docstring" comments
# and parse them into help and information messages using help()
ehelp <-function(fun, fn.name=as.character(substitute(fun)) ){
#' Enhanced-Help Function: ehelp()
#' This function displays docstring style comments used as help liners for user
#' defined functions.
#' @param fun function name of an user-defined function
#' @param fn name of the function (string)
#' @importFrom utils capture.output

    #############################################################
    # internal function to obtain first word after a keyword...
    #' @keywords internal
    firstWord <- function(strLine,kwrd) {
	clean.leading.spaces <- sub("^\\s+", "", strLine)
	pattern <- paste0(".*",kwrd,"\\s*| .*")
	match <- gsub(pattern, "", clean.leading.spaces)
	return(match)
    }

    #################
    # internal function to obtain the arguments of a function using text parsing
    #' @keywords internal
    getFnArgs <- function(line1) {
        # grab all the content between parenthesis...
	return( gsub("[\\(\\)]", "", regmatches(line1, gregexpr("\\(.*?\\)", line1))[[1]]) )
    }
    #################

    # internal function to remove the function label and extra spaces
    #' @keywords internal
    OnlyArgs <- function(line1) {
	# remove the word "function" from the string
	Args <- gsub("function","",line1)
	# remove leading and trailing spaces
	onlyArgs <- gsub("^\\s+|\\s+$", "", Args)
        return(onlyArgs)
    }

    # internal function to obtain arguments of a function using the "args()" fn
    #' @keywords internal
    FnArgs <- function(fun) {
	# obtain arguments of fun
	fnCall <- gsub("^\\s+", "", as.character(capture.output(args(fun))))
	# collapse fn call into one line and exclude the "NULL" returned from args()
	# getArgs <- paste(fnCall[1:length(fnCall)-1], collpase="")
	getArgs <- do.call(paste, c(as.list(fnCall[1:length(fnCall)-1]),collpase=""))
	#print(getArgs)
	# remove the word function and leading/trailing spaces
	return( OnlyArgs(getArgs) )
    }
    ##############################################################

    # check that there is an argument passed into the function
    if (missing(fun)) {
	stop("ehelp() requires the name of a function to be used as an argument.",
		'\n',
		"Try using ehelp(ehelp).",
		'\n')
    }

    # define keywords to look for
    keywords <- c("@fnName","@param","@descr","@usage","@example","@author", "@email", "@repo", "@ref")
    # define keywords to avoid
    kwrds.skip <- c("@keywords","@keywords internal","@importFrom","@export")
    # keywords descriptions
    keys.descrp <- c("Function Name:", "Arguments: \n", "Description: \n","\n### Usage: \n", "\n### Examples: \n","Author:", "Contact:", "Repository/URL:", "References: \n")
    names(keys.descrp) <- keywords
    # counters...
    keys.count <- rep(0,length(keywords))
    names(keys.count) <- keywords

    # first get the content of the function, i.e. its definition which should include the comments
    fnCorpus <- capture.output(print(fun))
    # get the function arguments
    fn.args <- FnArgs(fn.name)

    # identify the lines that contain the symbols "#'"
    helperCmts <- grepl("^[[:space:]]*#\'", fnCorpus)

    # intialize some containers for important info...
    # for now use the name of the fn detetected in the wrapper function
    fnName <- fn.name	#as.character(substitute(fun))
    fnArgs <- c()

    #  loop over the fn. corpus
    for (i in 1:length(helperCmts)) {
        # consider the lines marked as comments for help using "#'"
	if (helperCmts[i]) {
		#DBG: print(helperCmts[i])
		# get the current line and prune the "#'"
		fnLine <- gsub("#'","",fnCorpus[i])

		#DBG: print(fnLine)
		# some special cases to consider within the keywords: fnName & param
		# check for parameters to the fn
		if (grepl("@param",fnLine)) {
			#argFn <- gsub(".*@param (.+) \ .*", "\\1", fnLine)
			# clean leading spaces, and then grab the first 'word' after @param
			#argFn <- gsub(".*@param\\s*| .*", "", sub("^\\s+", "", fnLine))
			#fnArgs <- c(fnArgs,argFn)
			fnArgs <- c(fnArgs,firstWord(fnLine,"@param"))
		}
		# function name
		if (grepl("@fnName",fnLine)) {
			fnName <- firstWord(fnLine,"@fnName")
		}

		# check for keywords in the helper lines...
		flagKwrd <- FALSE
		for (kwrd in keywords) {
			if (grepl(kwrd,fnLine)) {
				# check whether this is the first instance of this feature...
				if (keys.count[kwrd] == 0) {
					cat(keys.descrp[kwrd])
				} 
				curLine <- gsub(kwrd,"",fnLine)
				cat('\t',curLine,'\n')
				keys.count[kwrd] <- keys.count[kwrd] + 1
				flagKwrd <- TRUE
			}
		}
		if (!flagKwrd) {
			# check whether the line does not include keywords to skip defined in kwrds.skip, eg. "@keywords internal"
			if (sum(sapply(kwrds.skip, grepl, fnLine)) == 0) {
				# just a comment line without any keyword...
				cat(fnLine,'\n')
			}
		}
	}
    }

    # summaryzing info...
    #if (keys.count["@usage"] == 0 )
    cat(keys.descrp["@usage"])
    #if (keys.count["@fnName"] !=0) {
		cat('\t',paste0(fnName,fn.args), '\n')
    #} else if (keys.count["@param"] != 0) {
    #		cat(keys.descrp["@param"])
    #}
    #if (keys.count["@param"] !=0) cat(paste0("(",paste0(fnArgs ,collapse=","),")"))
    #cat('\n')
    #print(fnArgs)
    #print(keys.count)
}


# Wrapper Help Function
# help wrapper function to redirect the calls to help either to our help.fn or
# the system help (utils::help)
help <- function(topic, package = NULL, lib.loc = NULL, verbose = getOption("verbose"), 
				try.all.packages = getOption("help.try.all.packages"), help_type = getOption("help_type")) {
#' Wrapper Help Function
#'
#' This function is a wrapper around the R's system help() function.
#' It allows the user to include docstring styles documentation and
#' displayed it as help or information to the users using the help()
#' command.
#'
#' Parameters are the same as in utils::help, see help(help,package='utils') for further details.
#'
#' @param topic    topic/or/function name to search for
#' @param package  package where to search
#' @param lib.loc  location of R libraries
#' @param verbose  for diplaying the filename
#' @param try.all.packages attempt to go trough all installed packages
#' @param help_type format of the displayed help (text,html, or pdf)
#' @export

    ###################################################################
    # this function is taken from the original "docstring" package,
    #   https://cran.r-project.org/web/packages/docstring/docstring.pdf
    # 
    # and it has been modified to make it work with "help" instead of "?"
    original <- function() {
        # Recreates the call but uses utils::`?`
        # So if we decide that docstring isn't the
        # way to go then we can still treat the input
        # like it would be treated if the docstring
        # package wasn't loaded.
        # TODO: Possibly try to play nice with devtools/sos?
        originalCall[[1]] <- quote(utils::help)
        return(eval(originalCall, parent.frame(2)))
    }
    ###################################################################

	# capture the original call to the fn
	originalCall <- match.call()

	# check that there is an argument passed into the function
	if (missing(topic)) {
		stop("Please provide an argument to the help function!",'\n')
	}

	# check whether it is not help for an specific package or library
	if (is.null(package) & is.null(lib.loc)) {

		# extract the name of the function/topic
		fn <- as.character(substitute(topic))

		# check whether the fn is an user-defined fn defined in the global environment
		# if not found will return NULL
		fun <- get0(fn, .GlobalEnv, inherits=FALSE)
		if (!is.null(fun) && fn != "help") {
			# check that it is indeed an user-defined fn
			if (is.function(topic)) {
				ehelp(topic,fn)
			} else {
				cat(paste0('"',fn,'"'), "defined in user-space memory but is NOT a function!",'\n\n')
			}
		} else {
			# check whether the topic is in the actual R help system
			return(original())
 		}
	} else {
		return(original())
	}
}

