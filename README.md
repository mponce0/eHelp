# eHelp

<!--
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version-last-release/ehelp)](https://cran.r-project.org/package=ehelp)
[![Downloads](https://cranlogs.r-pkg.org/badges/ehelp)](https://cran.r-project.org/package=ehelp)
-->

## Introduction
The "eHelp" (enhnaced-Help) package allows users to include "a-la-docstring" comments in their own functions and utilize the help() function to automatically provide documentation within an R session.

Inspired by Python's a-la-docstring comments and the existant "docstring" R package [1], the package "eHelp" attempts to offer similar functionalities by allowing comments "a-la-docstring" style to be displayed as help in user-defined functions.

### Rationale
Documenting code is among the "best practices" followed when developing code in a professional manner, and even when guided generation of documentation is possible while developing R packages, we still belive that offering users a tool that allows them to document their functions via docstring comments is useful.

Moreover it can be used for instructing and teaching best practices while training coders that are just starting.
Or, in this case the eHelp package could help package developer while prototyping their own packages, as eHelp will allow them to explore how the the help of the functions defined within their package will look like and even save this documentation in files of different formats.

The inclusion of "docstring" comments are an useful and easy way of allowing programmers to include comments and at the same time document their codes.
Unfortunately such functionality is not present in the R core and basic features for user-defined functions.

The main reason why we decided to create this package is because we noticed several issues with the already available in R "docstring" package:
* we have noticed that the 'docstring' package does not work with more than one function defined within a script
* sometimes the documentation is not updated even when the function is reloaded (ie. Windows OS)
* the package hasn't been updated or mantained since its creation in 2017 [2]
* we prefered to overload the "help()" function instead of the "?" one, which we find more frequently used
* another advantage of using the "help()" function, is that tab-completion works and we have overload the function so that it cascades down to the R utils::help() function when the user-defined function is not present in the working environment.

### Features
The "eHelp" package attempts to provide documentation for user-defined functions based on decorated "a-la-docstring" comments included in the function's definition.
It does this by employing a really "simple" approach in the sense that it does not attempt to generate roxygen based documentation for the user-defined functions, but instead it just displays the information decorated with  _#'_ directly into the console.
This, we belive, in this particular case represents an advantage, specially considering that the package is aimed to provide help for user-defined functions. For instance, one of the reported issues with the "docstring" package is that the documentation generated wasn't updated after the user-definitions were updated and re-sourced. 

Comments with docstrings should be included within the function definition, as eHelp will look into the body of the function for this type of comments.

An additional feature of the "eHelp" package is that it will automatically generate an "usage" report, independently of whether the user specified it on the docstring-ed comments utilizing the "@usage" keyword. It does this, by inspecting the function's definition and parsing an expression with the function's name and list of arguments.

The following keywords can be used to decorate and provide details as comments in user-defined functions:

```
@fnName :  provides the name of the function
@param  :  list the arguments and its description of the arguments expected by the function
@descr  :  general description of the function
@return :  description of what the function returns
@usage  :  how the function is called
@author :  name of the author(s) of the function
@email  :  contact information of the author(s)
@repo   :  repository where to get the function from
@ref    :  any suitable reference needed
```

Further keywords can be added on-demand, please contact the developer if you would like to add other keywords to the list.

Some keywords are explicited ignored, such as: "@keyword internal", "@importFrom", "@export"; as these won't contribute much to the usage of the user-defined functions.

### Highlighting
We have included extended functionalities to the "ehelp()" function, which allows the user to display the information about the requested function using highlighting features.
For such functionalities to work you will have to use
   ```ehelp(Name.of.Function, coloring=TRUE)```
this requires that the "crayon" package [3] is available (installed) in the system.


### Saving the documentation of the functions to file in different formats
Another additional feature of the ehelp() function, is that it can be
instructed to create a file with the content of the help for a given function
in file utilizing an specific file format for the output.
This is achived by indicating the argument ```output```  and one of the
following values:

output	 | file format
------	 | -----------
txt	 | plain text
ascii	 | similar to plain txt but including ESCape codes like the ones used for coloring the output in the R session
html	 | HTML format, the user can open the output with any web browser
latex	 | LaTeX format
markdown | Markdown format
---------------------------

When this option is used, the output generated will be saved in the current
working directory in a file named employing the following convention:

	NameOfTheFunction-eHelp.FMT

where ```NameOfTheFunction``` is the name of the function and ```FMT``` is the
correspodning extension format selected.

Capitalized options are also available and when used, not only the help associated
with the function is saved in the file but also the actual listing of the
function too.



## Installation

For using the "eHelp" package, first you will need to install it.

Thes table version can be downloaded from the CRAN repository:
```
install.packages("ehelp")
```

To obtain the development version you can get it from the github repository, i.e.
```
# need devtools for installing from the github repo
install.packages("devtools")

# install eHelp
devtools::install_github("mponce0/eHelp")

# load eHelp
library(eHelp)
```

## How does it work?
After loading the "eHelp" package, the function help() from the R system will be overloaded ("masked") by a wrapper function that allows us to redirect the calls to the help() function either to our eHelp() function or to the R's core help() one.
When the wrapper function detects that help is being invoqued in an user-defined function, then it offload the call to our own eHelp() function. The eHelp() function will parse the content of the inquired function looking for comments decorated with #' and parse them depending on their content. In particular, it will take special care of the comments including any of the keywords described above and the usage of the function.


## Examples
All what is needed for eHelp to offer help in your own defined functions is to add comments including " #' " and its respective keywords.
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

### Usage:
   compute3Dveloc(x, y, z, t)
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
Function Name:	   myTestFn 

 This is just an example of a dummy fn 
 
 
Contact:	   myemail@somewhere.org 
Author:	   author
 @demo 

### Examples: 
	   myTestFn(x0,y0,z0) 

### Usage: 
	 myTestFn(x, y, z, t = 0) 
```



It is also possible to invoque the "ehelp()" function directly, and in that way further options are available:
```
> ehelp(myTestFn, coloring=TRUE)
__Function Name:__	   myTestFn 

 This is just an example of a dummy fn 
 
 
__Contact:__	   myemail@somewhere.org 
__Author:__	   author
 @demo 

### Examples:
	   myTestFn(x0,y0,z0) 

__### Usage:__
	 myTestFn(x, y, z, t = 0)
```


Additionaly is possible to use ehelp() for saving of documentation of a
function into a file with an specific file format, this is acieved by specifying the ```output``` argument in ehelp().
Available formats are:
txt (plain-text), ascii (text with ESC-codes for coloring), latex, html, and markdown.
Additionally, capitalized versions of these formats, will also include
the listing of the function, eg.

```
ehelp(myTestFn, output="latex")
```
**myTestFn-eHelp.tex written to CURRENT_DIR**
...

```
ehelp(myTestFn, output="TXT")

ehelp(myTestFn, coloring=TRUE, output="HTML")

ehelp(myTestFn, coloring=TRUE, output="ASCII")

ehelp(myTestFn, coloring=TRUE, output="markdown")
```


### References
[1] https://cran.r-project.org/package=docstring

[2] https://github.com/dasonk/docstring

[3] https://github.com/r-lib/crayon
