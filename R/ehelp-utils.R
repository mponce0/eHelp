# ehelp-utils.R
#  -- M.Ponce


# Define methods associated with ehelp.obj
#print <- function(ehelp.obj){
##' method associated with ehelp objects
##' @param ehelp.obj ehelp object
##' @keywords internal
#       UseMethod("print",ehelp.obj)
#}

print.ehelp <- function(ehelp.obj) {
#' function associated to the ehelp object method
#' @param ehelp.obj ehelp object
#' keywords internal
   for (obj.line in 1:length(ehelp.obj)) {
        cat(as.character(ehelp.obj[obj.line]))
   }
}


### OUTPUT functions to save information to files...

write.ehelp <- function(X.obj,filename){
#' function for writing ehelp output to a local text file
#' @param X.obj ehelp object
#' @param filename name of the file where to write the documentation
#' keywords internal
        lines <- paste0("-----------------------",'\n')
        X.obj <- c(lines,X.obj,lines)
        utils::write.table(X.obj,file=filename,sep="", col.names=FALSE,row.names=FALSE, quote=FALSE)
}

write.Fncorpus <- function(fnListing, filename){
#' @param fnListing  listing of fn to write to file
#' @param filename name of the file where to write the documentation
#' keywords internal
        lines <- paste0("/* ################################################ */",'\n')
        listing <- c(lines,fnListing,lines)
        utils::write.table(listing,file=filename,sep="", col.names=FALSE,row.names=FALSE, quote=FALSE, append=TRUE)
}

