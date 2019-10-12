context("running tests on ehelp...")

# load auxiliary functions to use in the tests
# some of the fns are not loaded with their comments when sourcing the auxFns.R
# file, hence the actual defn were saved in an R session file
# "eHelp-test.RData"
source("auxFns.R")
load("eHelp-test.RData")


# printing locales and  environment for additional information
#####
print('beggining of test')

Sys.setlocale("LC_COLLATE","en_CA.UTF-8")
print("~~~~~~~~~~~~")
print(sessionInfo())
print(Sys.getlocale())
print("~~~~~~~~~~~~")

ehelp(dummyFn)

print( capture.output(cat(paste(capture.output(ehelp(dummyFn),type='message'),collapse='')),type='message') )
print( capture.output(ehelp(dummyFn),type='message') )

aaa<-capture.output(ehelp(dummyFn),type='output')
print(aaa)

print("~~~~~~~~~~~~")
print(sessionInfo())
print(Sys.getlocale())
print("~~~~~~~~~~~~")
#####


# TESTS

# test 0: "nill" (void) fn
test_that("testing eHelp documentation generated for user-defined functions",{
	output.0 <- capture.output(cat(paste(capture.output(ehelp(nillFn,testing=T)),collapse='')))
	#expectedOutput.0 <- "  ### Usage:   \tnillFn()  "
	expectedOutput.0 <- "### Usage: \tnillFn()"
	expect_match(output.0,expectedOutput.0, fixed=TRUE)
})

# test #1: dummy Fn
test_that("testing eHelp documentation generated for user-defined functions",{
	output.1 <- capture.output(cat(paste(capture.output(ehelp(dummyFnX,testing=T)),collapse='')))
	#expectedOutput.1 <- "  ### Usage:   \tdummyFnX(x, y, z0 = list(x1, x2, x3), t0, t1, tn = list(ta,  tb, tc), ...)  "
	expectedOutput.1 <- "### Usage: \tdummyFnX(x, y, z0 = list(x1, x2, x3), t0, t1, tn = list(ta,  tb, tc), ...)"
expect_match(output.1,expectedOutput.1, fixed=TRUE)
})

# test #2: dummyFn with more content
test_that("testing eHelp documentation generated for user-defined functions",{
	output.2 <- capture.output(cat(paste(capture.output(ehelp(dummyFn,testing=T)),collapse='')))
#	output.2 <- do.call(cat, c(as.list(capture.output(ehelp(dummyFn))),collapse=""))
	expectedOutput.2 <- "Function Name:\t      dummyFn   Arguments:   \t       ...  anything        Description:   \t       this is just an example function to demonstrate how the eHelp package works     ### Usage:   \t       dummyFn()   Author:\t      tester   Contact:\t       email.adresss   Repository/URL:\t        https://github.com/mponce0/eHelp   References:   \t         https://github.com/mponce0/eHelp     ### Usage:   \t dummyFn(...)  "
#	expectedOutput.2 <- "Function Name:\t      dummyFn  Arguments:  \t       ...  anything      Description:  \t       this is just an example function to demonstrate how the eHelp package works   ### Usage:  \t       dummyFn()  Author:\t      tester  Contact:\t       email.adresss  Repository/URL:\t        https://github.com/mponce0/eHelp  References:  \t         https://github.com/mponce0/eHelp   ### Usage:  \t dummyFn(...)  "
	expectedOutput.2 <- "Function Name:\t      dummyFn Arguments: \t       ...  anything    Description: \t       this is just an example function to demonstrate how the eHelp package works ### Usage: \t       dummyFn() Author:\t      tester Contact:\t       email.adresss Repository/URL:\t        https://github.com/mponce0/eHelp References: \t         https://github.com/mponce0/eHelp ### Usage: \tdummyFn(...)"
expect_match(output.2,expectedOutput.2, fixed=TRUE)
})

# test #3: dummy Fn with more keywords
test_that("testing eHelp documentation generated for user-defined functions",{
	output.3 <- utils::capture.output(cat(paste(utils::capture.output(ehelp(myTestFn,testing=T)),collapse='')))
	expectedOutput.3 <- #"Function Name:\t   myTestFn       This fn does not do anything other than having docstrings comments      Arguments:   \t   x BH position in x-axis   \t   y BH position in y-axis   \t   z BH position in z-axis   \t   t time to merger      Contact:\t   mponcec@gmail.com   Author:\t   mponce    @demo     ### Examples:   \t   myBHFn(x0,y0,z0)     ### Usage:   \t myTestFn(x, y, z, t, W)  "
				"Function Name:\t   myTestFn   This fn does not do anything other than having docstrings comments  Arguments: \t   x BH position in x-axis \t   y BH position in y-axis \t   z BH position in z-axis \t   t time to merger  Contact:\t   mponcec@gmail.com Author:\t   mponce  @demo  @example myBHFn(x0,y0,z0) ### Usage: \tmyTestFn(x, y, z, t, W)"
expect_match(output.3,expectedOutput.3, fixed=TRUE)
})


### END OF TESTS ###
