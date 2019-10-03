## Introduction
The "eHelp" (enhnaced-Help) package allow users to include "a-la-docstring" comments in their own functions and utilize the help() function to automatically provide documentation within the R session.

Inspired by Python's a-la-docstring comments and the existant "docstring" R package (https://cran.r-project.org/web/packages/docstring/vignettes/docstring_intro.html), the package "eHelp" attempts to offer similar functionalities by allowing comments "a-la-docstring" style to be displayed as help in user-defined functions.

Documenting code is among the "best practices" to follow when developing code in a professional manner, and even when guided  generation of documentation is possible while developing R packages, we still belive that offering users a tool that allows them to document their functions using docsting comments is useful.
Moreover it can be used for teaching best practices while training coders that are just starting.

The inclusion of "docstring" comments are an useful and easy way of allowing programmers to include comments and at the same time document their codes.
Unfortunately such functionality is not present in the R core and basic features for user-defined functions.

The main reason why we decided to create this package is because we noticed several issues with the already available in R "docstring" package:
* we have noticed that the 'docstring' package does not work with more than one function defined within a script
* sometimes the documentation is not updated even when the function is reloaded (ie. Windows OS)
* the package hasn't been updated or mantained since its creation in 2017 (https://github.com/dasonk/docstring)
* we prefered to overload the "help()" function instead of the "?" one, which we find more frequently used
* another advantage of using the "help()" function, is that tab-completion works and we have overload the function so that it cascades down to the R utils::help() function when the user-defined function is not present in the working environment.

### Features
The "eHelp" package attempts to provide documentation for user-defined functions based on decorated "a-la-docstring" comments included in the function's defition.
It does this employing a really "simple" approach, in the sense that does not attempt to generate roxygen based documentation for the user-defined functions, but instead it just displays the information decorated with  _#'_ directly into the console.
This, we belive, in this particular case represents an advantage, specially considering that the package is aimed to provide help for user-defined functions. For instance, one of the reported issues with the "docstring" package is that the documentation generated wasn't updated after the user-definitions were updated and re-sourced. 

Comments with docstrings should be included within the function definition, as eHelp will look into the body of the function for this type of comments.

An addtional feature of the "eHelp" package is that it will automatically generate an "usage" report, independently of whether the user specified it on the docstring-ed comments utilizing the "@usage" keyword. It does this, by inspecting the function's definition and parsing an expression with the function's name and list of arguments.

The following keywords can be used to decorate and provide details as comments in user-defined functions:

```
@fnName :  provides the name of the function
@param  :  list the arguments and its description of the arguments expected by the function
@descr  :  general description of the function
@usage  :  how the function is called
@author :  name of the author(s) of the function
@email  :  contact information of the author(s)
@repo   :  repository where to get the function from
@ref    :  any suitable reference needed
```

Further keywords can be added on-demand.


### Installation

For using the "eHelp" package, first you will need to install it.
To obtain the latest version you can get it from the github repository, i.e.
```
# need devtools for installing from the github repo
install.packages("devtools")

# install eHelp
devtools::install_github("mponce0/eHelp")

# load eHelp
library(eHelp)
```

### How does it work?
After loading "eHelp" the function help() from the R system will be overloaded by a wrapper function that allows to intersect the calls to the help() function.
When the wrapper function detects that help is being invoqued in an user-defined function, then it offload the call to our own eHelp() function. The eHelp() function will parse the content of the inqiured function looking for comments decorated with #' and parse them depending on their content. In particular will take special care of the ones inclduing any of the keywords described before.


## Examples
All what is needed for eHelp to offer help in your own defined functions is to add comments including "#'" and its respective keywords.
We offer below some examples, just recall to load the eHelp package before using help() with your own functions.

```
compute3Dveloc <- function(x,y,z,t){
#' @fnName compute3Dveloc
#' this function computes the velocity of an object in a 3D space
#' @param x  vector of positions in the x-axis
#' @param y  vector of positions in the y-axis
#' @param z  vector of positions in the z-axis
#' @param t  time vector corresponding to the position vector

   # number of elements in vectors
   n <- length(t)
   # compute delta_t
   delta_t <- t[2:n]-t[1:n-1]
   # compute delta_x
   delta_x <- x[2:n]-x[1:n-1]
   # compute delta_y
   delta_y <- y[2:n]-y[1:n-1]
   # compute delta_z
   delta_z <- z[2:n]-z[1:n-1]
   # do actual computation of velocity...
   veloc3D <- list(delta_x/delta_t, delta_y/delta_t, delta_z/delta_t)
   # return value
   return(veloc3D)
}
```

```
> help(compute3Dveloc)
Function Name:	   compute3Dveloc
 this function computes the velocity of an object in a 3D space 
Arguments: 
	   x  vector of positions in the x-axis 
	   y  vector of positions in the y-axis 
	   z  vector of positions in the z-axis 
	   t  time vector corresponding to the position vector 

   compute3Dveloc(x,y,z,t)
```


Even when the @fnName and @params are not definied, the usage will be generated based on the actual function definition:
```
myTestFn <- function(x,y,z,t=0) {
#'
#' This is just an example of a dummy fn
#'
#'
#' @email myemail@somewhere.org
#' @author author
#
#
#' @demo
#' @example myTestFn(x0,y0,z0)
}
```
```
> help(myTestFn)

 This is just an example of a dummy fn 
 
 
Contact:	   myemail@somewhere.org 
Author:	   author
 @demo 

### Examples: 
	   myTestFn(x0,y0,z0) 

### Usage: 
	 myTestFn(x,y,z,t=0) 
```



