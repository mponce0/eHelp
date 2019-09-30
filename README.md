Inspired by Python's a-la-docstring comments and the existant "docstring" R package (https://cran.r-project.org/web/packages/docstring/vignettes/docstring_intro.html), this package attempts to offer similar functionalities by allowing comments "a-la-docstring" style to be displayed as help in user-defined functions. 

The main reason why we decided to create this package is because we noticed some issues with the already avaialable in R "docstring" package:
* we have noticed that the package does not work with more than one function defined within a script
* the package hasn't been updated or mantained since its creation in 2017 (https://github.com/dasonk/docstring)
* we prefered to overload the "help()" function instead of the "?" one.

Also, our package is simpler in the sense that does not attempt to generate roxygen based documentation for the user-defined functions but instead just display the information decorated with "#'" in the console.

The following keywords can be used to decorate and provide details as comments in user-defined functions:

```
@fnName :  provides the name of the function
@param  :  list the arguments and its description of the arguments expected by the function
@usage  :  how the function is called
@author :  name of the author(s) of the function
@email  :  contact information of the author(s)
@repo   :  repository where to get the function from
@ref    :  any suitable reference needed
```

Further keywords can be added on-demand.

## Examples

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


Even when the @fnName and @params are not definied, the usage will be generated:
```
myTestFn <- function(x,y,z,t) {
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
	 myTestFn(x,y,z,t) 
```
