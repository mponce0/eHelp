#' Enahnced-Help Function: ehelp()
#' This function displays docstring style comments used as help liners for user
#' definied functions. 
#' @param function name of an user-defined function
ehelp <-function(fun){
# enhanced help function, capable of extracting "a-la docstring" comments
# and parse them into help and information messages using help()

    # define keywords to look for
    keywords <- c("@FnName","@param","@usage","@author", "@email", "@repo", "@ref")
    # keywords descriptions
    keys.descrp <- c("Function Name:", "Arguments:", "Usage:", "Author:", "Contact:", "Repository/URL:", "References:")
    # counters...
    keys.count <- rep(0,length(keywords))

    # first get the content of the function, i.e. its definition which should include the comments
    fnCorpus <- capture.output(print(fun))

    # identify the lines that contain the symbols "#'"
    helperCmts <- grepl("^[[:space:]]*#\'", fnCorpus)

    # intialize some flags
    fnArgs <- c()

    #  loop over the fn. corpus
    for (i in 1:length(helperCmts)) {
        # consider the lines marked as comments for help using "#'"
	if (helperCmts[i]) {
		# get the current line and prune the "#'"
		fnLine <- gsub("#'","",fnCorpus[i])
		# check for parameters to the fni
		if (grepl("@param",fnLine)) {
			if (length(fnArgs) == 0) {
				cat("Arguments:", '\n')
			}
			argLine <- gsub("@param","",fnLine)
			cat('\t',argLine,'\n')
			argFn <- gsub(".*@param (.+) \ .*", "\\1", fnLine)
			fnArgs <- c(fnArgs,argFn)
		} else {
			cat(fnLine,'\n')
		}
		# check for keywords in the helper lines...
		for (kwrd in keywords) {
			if (grepl(kwrd,fnLine)) {
			
				keys.count <- keys.count + keywords==kwrd	
			}
		}
	}
    }

    # also the usage
    #fnDefn <- fnCorpus[grepl(fun,fnCorpus[grepl("<-",fnCorpus)])]
    #cat(fnDefn)
}



#' Wrapper Help Function
#'
#' This function is a wrapper around the R's system help() function.
#' It allows the user to include docstring styles documentation and
#' displayed it as help or information to the users using the help()
#' command.
#' @param topic topic/or/function name to search for
#' @param ...   same parameters as help()
#' @export
help <- function(topic, package = NULL, lib.loc = NULL, verbose = getOption("verbose"), 
				try.all.packages = getOption("help.try.all.packages"), help_type = getOption("help_type")) {
# help wrapper function to redirect the calls to help eitehr to our help.fn or the system help (utils::help)

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

	# check whether it is not help for an specific package or library
	if (is.null(package) & is.null(lib.loc)) {

		# extract the name of the function/topic
		fn <- as.character(substitute(topic))

		# check whether the fn is an user-defined fn defined in the global environment
		# if not found will return NULL
		fun <- get0(fn, .GlobalEnv, inherits=FALSE)
		if (!is.null(fun) && fn != "help") {
			#print(fun)
			ehelp(fun)
		} else {
			# check whether the topic is in the actual R help system
			return(original())
 		}
	} else {
		return(original())
	}
}

