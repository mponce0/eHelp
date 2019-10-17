# eHelp.R
#  -- M.Ponce

# Enhanced-Help Function: ehelp()
# enhanced help function, capable of extracting "a-la docstring" comments
# and parse them into help and information messages using help()
ehelp <-function(fun, fn.name=as.character(substitute(fun)), coloring=FALSE, testing=FALSE) {
#' Enhanced-Help Function: ehelp()
#' This function displays docstring style comments used as help liners for user
#' defined functions.
#' @param fun function name of an user-defined function
#' @param fn name of the function (string)
#' @param coloring a Boolean flag indicating whether to use colors for displaying messages
#' @param testing a Boolean variable, indicating whether the help fn is being tested (information sent to the console will be done using cat() instead of message())
#'
#' @importFrom utils capture.output
#'
#' @examples
#' myTestFn <- function(x,y,z,t=0) {
#' #'
#' #' This is just an example of a dummy fn
#' #'
#' #'
#' #' @email myemail@somewhere.org
#' #' @author author
#' #
#' #
#' #' @demo
#' #' @examples myTestFn(x0,y0,z0)
#' }
#' 
#' ehelp(myTestFn)
#'
#' ## this requires the "crayon" package to work
#' ehelp(myTestFn, coloring=TRUE)
#'
#'
#' @export

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

    ################# internal functions for checks ###############################

    # internal function to check whether packages are available and load them
    #' @importFrom utils installed.packages 
    #' @keywords internal
    check_pkg <- function(pckg) {
	# if package is installed locally then load
	if (pckg %in% rownames(installed.packages())) {
		do.call('library', list(pckg))
		return(TRUE)
	} else  {
		return(FALSE)
	}
    }

    ##################

    # internal function to check that a fn is present in the Global environment
    # NEEDS FIX TO parse the fn name
    checkFnGE <- function(fun, fn.name=as.character(substitute(fun)) ) {
	print(fn.name)
        # check whether the fn is an user-defined fn defined in the global environment
        # if not found will return NULL
        fun <- get0(fn.name, .GlobalEnv, inherits=FALSE)
        if (is.null(fun)) {
		stop(paste0('"',fn.name,'"'), " not present (not defined) in the current session!",'\n\n')
	} else if(!is.function(fun)){
		stop(paste0('"',fn.name,'"'), " defined in user-space memory but is NOT a function!",'\n\n')
	}
    }

    ##############################################################

    # internal function to switch between commands to display information into console
    #' @keywords internal
    xcat <- function(msg,appendLF=FALSE, testing=FALSE){
	if (!testing) {
		message(msg,appendLF=appendLF)
        } else {
		cat(msg)
	}
    }

    ##############################################################
    ##############################################################


    # check that there is an argument passed into the function
    if (missing(fun)) {
	stop("ehelp() requires the name of a function to be used as an argument.",
		'\n',
		"Try using ehelp(ehelp).",
		'\n')
    } else {
	# check that the function received actually exists in global space
	#checkFnGE(fun)
        fn <- get0(fn.name, .GlobalEnv, inherits=FALSE)
        if (is.null(fn)) {
                stop(paste0('"',fn.name,'"'), " not present (not defined) in the current session!",'\n\n')
        } else if(!is.function(fun)){
                stop(paste0('"',fn.name,'"'), " defined in user-space memory but is NOT a function!",'\n\n')
        }

    }


    # check coloring... if it is set to TRUE, then attempt to load 'crayon'...
    if (coloring) coloring <- check_pkg("crayon")


    # define keywords to look for
    keywords <- c("@fnName","@param","@descr","@usage","@@examples","@author", "@email", "@repo", "@ref")
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
					if (coloring) {
						xcat(crayon::inverse(keys.descrp[kwrd]), appendLF=FALSE, testing)
					} else {
						xcat(keys.descrp[kwrd], appendLF=FALSE, testing)
					}
				} 
				curLine <- gsub(kwrd,"",fnLine)
				xcat(paste('\t',curLine,'\n'),appendLF=FALSE, testing)
				keys.count[kwrd] <- keys.count[kwrd] + 1
				flagKwrd <- TRUE
			}
		}
		if (!flagKwrd) {
			# check whether the line does not include keywords to skip defined in kwrds.skip, eg. "@keywords internal"
			if (sum(sapply(kwrds.skip, grepl, fnLine)) == 0) {
				# just a comment line without any keyword...
				xcat(paste(fnLine,'\n'),appendLF=FALSE, testing)
			}
		}
	}
    }

    # summaryzing info...
    #if (keys.count["@usage"] == 0 )
    if (coloring) {
	#xcat(crayon::inverse(keys.descrp["@usage"]),appendLF=FALSE, testing)
	xcat(crayon::bgWhite(keys.descrp["@usage"]),appendLF=FALSE, testing)
	xcat(paste0('\t',crayon::blue$bgWhite(paste0(fnName,fn.args)), '\n'),,testing)
    } else {
	xcat(keys.descrp["@usage"],appendLF=FALSE, testing)
	xcat(paste0('\t',paste0(fnName,fn.args), '\n'),,testing)
    }
    #if (keys.count["@fnName"] !=0) {
		#xcat(paste0('\t',paste0(fnName,fn.args), '\n'),,testing)
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
#'
#' @examples
#' compute3Dveloc <- function(x,y,z,t){
#' #' @fnName compute3Dveloc
#' #' this function computes the velocity of an object in a 3D space
#' #' @param x  vector of positions in the x-axis
#' #' @param y  vector of positions in the y-axis
#' #' @param z  vector of positions in the z-axis
#' #' @param t  time vector corresponding to the position vector
#'
#'    # number of elements in vectors
#'    n <- length(t)
#'    # compute delta_t
#'    delta_t <- t[2:n]-t[1:n-1]
#'    # compute delta_x
#'    delta_x <- x[2:n]-x[1:n-1]
#'    # compute delta_y
#'    delta_y <- y[2:n]-y[1:n-1]
#'    # compute delta_z
#'    delta_z <- z[2:n]-z[1:n-1]
#'    # do actual computation of velocity...
#'    veloc3D <- list(delta_x/delta_t, delta_y/delta_t, delta_z/delta_t)
#'    # return value
#'    return(veloc3D)
#' }
#'
#' help(compute3Dveloc)
#'
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
				warning(paste0('"',fn,'"'), " defined in user-space memory but is NOT a function!",'\n\n')
			}
		} else {
			# check whether the topic is in the actual R help system
			return(original())
 		}
	} else {
		return(original())
	}
}

