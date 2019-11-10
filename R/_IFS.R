#       return(0)
#
#       # txt: output the help of the fn in plain "txt" 
#       if (output=="txt") {
#               #write.ehelp(ehelp.obj['txt'], file=paste0(fnName,"-eHelp.txt"))
#               write.fmt(ehelp.obj,output,paste0(fnName,"-eHelp.txt"))
#       # TXT: output the help of the fn in plain "txt" + listing of the fn
#       } else if (output == "TXT") {
#                #write.ehelp(ehelp.obj['txt'], file=paste0(fnName,"-eHelp.TXT"))
#               write.fmt(ehelp.obj,output,file=paste0(fnName,"-eHelp.TXT"),leaveOpen=T)
#                write.Fncorpus(fnName, fnCorpus, filename=paste0(fnName,"-eHelp.TXT"))
#       # html: output the help of the fn in HTML format
#        } else if (output == "html") {
#               #write.html(ehelp.obj, file=paste0(fnName,"-eHelp.html"))
#               write.fmt(ehelp.obj,output,file=paste0(fnName,"-eHelp.html"))
#       # HTML: output the help of the fn in HTML format + listing of the fn
#       } else if (output == "HTML") {
#               #write.html(ehelp.obj, ending="</P>", file=paste0(fnName,"-eHelp.HTML"))
#               write.fmt(ehelp.obj,output,file=paste0(fnName,"-eHelp.HTML"),leaveOpen=T)
#               write.Fncorpus(fnName, fnCorpus, filename=paste0(fnName,"-eHelp.HTML"),
#                               begining="<p> <code>", ending="</code></p> \n </body> \n </HTML>", EoL="<br> \n")
#       # latex: output the help for the dn in LaTeX format
#       } else if (output == "latex") {
#               #write.latex(ehelp.obj, file=paste0(fnName,"-eHelp.tex"))
#               write.fmt(ehelp.obj,output,paste0(fnName,"-eHelp.tex"))
#       } else if (output == "LATEX") {
#               #write.latex(ehelp.obj, ending="", file=paste0(fnName,"-eHelp.TEX"))
#               write.fmt(ehelp.obj,output,paste0(fnName,"-eHelp.TEX"),leaveOpen=T)
#               write.Fncorpus(fnName, fnCorpus, filename=paste0(fnName,"-eHelp.TEX"),
#                       begining="\\section*{Listing}\n\\label{listing} \n \\begin{minipage}{0.75\\textwidth}\n \\small \n \\begin{verbatim}",
#                       ending="\\end{verbatim} \n \\end{minipage} \n\n \\end{document}",
#                       EoL="\n")
#       # ascii: same as plain-txt but with ESC-codes for coloring...
#       } else if (output == "ascii") {
#               #write.ascii(ehelp.obj, ending="", file=paste0(fnName,"-eHelp.asc"))
#               write.fmt(ehelp.obj,output,file=paste0(fnName,"-eHelp.asc"))
#       } else if (output == "ASCII") {
#               #write.ascii(ehelp.obj, ending="", file=paste0(fnName,"-eHelp.ASC"))
#               write.fmt(ehelp.obj,output,file=paste0(fnName,"-eHelp.ASC"), leaveOpen=T)
#               write.Fncorpus(fnName, fnCorpus, filename=paste0(fnName,"-eHelp.ASC"))
#       } else if (output == "markdown") {
#               write.fmt(ehelp.obj,output,paste0(fnName,"-eHelp.md"))
#       } else if (output == "MARKDOWN") {
#               write.fmt(ehelp.obj,output,paste0(fnName,"-eHelp.MD"), leaveOpen=T)
#               write.Fncorpus(fnName, fnCorpus, filename=paste0(fnName,"-eHelp.MD"),
#                       begining="```", ending="```", EoL="\n")
#       } else if (output != "none") {
#               message("The selected output format <<",output,">> is not supported. \n",
#                       "Valid options are: ",paste0(valid.outputFmts,sep=" "),"\n")
#               }
