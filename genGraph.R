#!/usr/bin/env Rscript --vanilla
rootLetters <- c("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m")

##library(yaml, lib.loc=".") ## Tells R where to find the YAML lib

## all args are strings

## letters can be a single letter(a), a range(a-c), a list(a,b,g), or a combination of all 3
## letters MUST be given in order(e.g. a-d,f,l-m), white space is not allowed
## If letters is not a single letter, an aggregate will be returned
## startDate and endDate are inclusive and take the form YYYY/MM/DD
## metric matches the YAML metric to be returned, it MUST be present, e.g. udp-request-sizes
## submetric matches the YAML submetric, it is optional, e.g. 16-31
rootData <- function(letters, startDate, endDate, metric, submetric){
    letters <- tolower(letters)
    fileLetters <- c();
    toks <- unlist(strsplit(letters, ""))

    ii <- 0
    while(ii < length(toks)){
        ii <- ii + 1
        if(charmatch(toks[ii], rootLetters, nomatch=-1) != -1){
            fileLetters <- c(fileLetters, toks[ii])
        }else if(toks[ii] == '-'){
                start <- charmatch(toks[ii-1], rootLetters) + 1
                end <- charmatch(toks[ii+1], rootLetters)
                
                for(jj in start:end){
                    fileLetters <- c(fileLetters, rootLetters[jj])
                }
                ii <- ii + 1
            }
    }
    
    cat(length(fileLetters), "\n")
    cat(unlist(fileLetters), "\n")
}

rootData('a,d-h',"","","","")

##cat("Begin execution\n")
##test <- yaml.load_file("test.yaml")
##cat names(test)
##cat(length(test))
##cat("\n")
##cat(test[[1]])
##cat("\n")
##cat(test[["metric"]])
##cat("\n")
##cat(test[["end-period"]])
##cat("\n")
##cat(test[["size"]][[2]])
##cat("\n")
##cat(names(test[["size"]]))
##cat("\n")
##cat(size[["2"]]

##x <- c(10.4, 5.6, 3.1, 6.4, 21.7)
##y <- c(10.4, 5.5, 3.1, 6.4, 21.7)

##png(filename="figure.png", height=295, width=300, bg="white")

##plot(test)

## Create box around plot
##box()

## Turn off device driver (to flush output to png)
##dev.off()



