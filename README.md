Inspired by Python's a-la-docstring comments and the existant "docstring" R package (https://cran.r-project.org/web/packages/docstring/vignettes/docstring_intro.html), this package attempts to offer  similar functionalities.

The main reason why we decided to create this package is because we noticed some issue with the already avaialble in R "docstring" package:
* we have noticed that the package does not work with more than one function defined within a script
* the package hasn't been updated or mantained since its creation in 2017 (https://github.com/dasonk/docstring)
* we prefered to overload the "help()" function instead of the "?" one.

Also, our package is simpler in the sense that does not attempt to generate roxygen based docuemntation fo the user-defined functions but instead just display the information decorated with "#'" in the console.

We are working in providing further features, as we decided to define extended set of keywords which can help to categoriuzew the information provided to the user, such as:

@FnName
@param
@usage
@author
@email
@repo
@ref
