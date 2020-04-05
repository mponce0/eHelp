simulatePackage <- function(pkgLocation=NULL) {
#' function that allows to load the functions from a package in preparation for
#' CRAN, as if it is being loaded by loading all the fns defined in the R
#' sub-directory of the package, ie. "myPckg/R"
#'
#' @param  pkgLocation  path to the base loaction of the package, under which
#' is expected to found the R sub-directory 
#'
#' @export
#'
#' #@examples
#' #simulatePackage("myPckg")
#'

	checkPkgLocation <- function(pkgLoc) {

		# location of R sources within the Pckg
		R.pckg.loc <- paste0(pkgLoc,"/","R/")

		if (!dir.exists(pkgLoc)) {
			stop(pkgLoc," is not a valid directory! Please indicate the 'base' location of your package")
		} else if (!dir.exists(R.pckg.loc)) {
			warning("There isn't an R subdirectory found in the indicated location: ",pkgLoc, " -- will asumme ", pkgLoc, " to search for R sources")
			R.pckg.loc <- pkgLoc
		}

		return(R.pckg.loc)
	}


	# if a package location is not specified will assume current directory
	if (is.null(pkgLocation)) {
		pkgLocation <- getwd()
	}

	# first try to see in there is an "R" subir within the Pckg location
	R.pckg.loc <- checkPkgLocation(pkgLocation)

	# return to original location
	previous.loc <- getwd()
	on.exit(setwd(previous.loc))

	# cd into package location
	setwd(R.pckg.loc)

	#pkg.files <- dir()
	pkg.files <- list.files(pattern = "\\.r$",ignore.case=T)

	# fns before loading package...
	before <- names(as.list(.GlobalEnv))

	if ( length(pkg.files) > 1 ) {
		cat("loading package from ",R.pckg.loc,'\n')
		for (pkg.file in pkg.files) {
			cat('\t'," . . . loading ",pkg.file, '\n')
			source(pkg.file)
		}
	} else {
		stop("There weren't any *R* files found in ",R.pckg.loc)
	}

	# fns after loading package...
	after <- names(as.list(.GlobalEnv))

	# new fns loaded...
	if (sum(! after %in% before) > 0) {
		cat(paste(rep('-',80),collapse=""),'\n')
		cat("Functions and objects  loaded...",'\n')
		#for (obj in as.list(.GlobalEnv)) {
		#for (obj in ls()) {
		#	if (class(eval(parse(text=obj)))=='function') {
		#		print(obj)
		#	}
		#}
		print(after[!(after %in% before)])
		cat(paste(rep('-',80),collapse=""),'\n') 
	}

}
