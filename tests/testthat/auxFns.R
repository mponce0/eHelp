# auxiliary function to be used as targets for the eHelp package test suite

# trivial fn
# this function does nothing, neither has any docstring comment
nillFn <- function(){}

# another function without a body but with several 'a-la-docstring' comments
dummyFn <- function(...) {
  #' @fnName  dummyFn
  #' @param   ...  anything
  #'
  #' @descr   this is just an example function to demonstrate how the eHelp package works
  #' @usage   dummyFn()
  #' @author  tester
  #' @email   email.adresss
  #' @repo    https://github.com/mponce0/eHelp
  #' @ref     https://github.com/mponce0/eHelp
  #
}

# dummy function with many arguments
# and no docstring comments
dummyFnX <- function(   x,y, z0=list(x1,x2,x3),
                        t0,t1,tn=list(ta,tb,tc),
                        ...) {       
	# dummy function that retuirns NULL
        return(NULL)
}


# dummy function with several arguments and docstring comments
myTestFn <- function(x,y,z,t,
                        W) {
#' @fnName myTestFn
#'
#' This fn does not do anything other than having docstrings comments
#'
#' @param x BH position in x-axis
#' @param y BH position in y-axis
#' @param z BH position in z-axis
#' @param t time to merger
#'
#' @email mponcec@gmail.com
#' @author mponce
#
#
#' @demo
#' @example myBHFn(x0,y0,z0)
}

