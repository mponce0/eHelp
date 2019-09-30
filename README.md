Inspired by Python's a-la-docstring comments and the existant "docstring" R package (https://cran.r-project.org/web/packages/docstring/vignettes/docstring_intro.html), this package attempts to offer similar functionalities by allowing comments "a-la-docstring" style to be displayed as help in user-defined functions. 

The main reason why we decided to create this package is because we noticed some issues with the already avaialable in R "docstring" package:
* we have noticed that the package does not work with more than one function defined within a script
* the package hasn't been updated or mantained since its creation in 2017 (https://github.com/dasonk/docstring)
* we prefered to overload the "help()" function instead of the "?" one.

Also, our package is simpler in the sense that does not attempt to generate roxygen based documentation for the user-defined functions but instead just display the information decorated with "#'" in the console.

The following keywords can be used to decorate and provide details as comments in user-defined functions:

@fnName :  provides the name of the function
@param  :  list the arguments and its description of the arguments expected by the function
@usage  :  how the function is called
@author :  name of the author(s) of the function
@email  :  contact information of the author(s)
@repo   :  repository where to get the function from
@ref    :  any suitable reference needed

Further keywords can be added on-demand.
