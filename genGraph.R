#!/usr/bin/env Rscript --vanilla
##  The file is part of the RSSAC002 Graphing API.
##
##  The RSSAC002 Graphing API is free software: you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation, either version 3 of the License, or
##  (at your option) any later version.
##
##  The RSSAC002 Graphing API is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
##  GNU General Public License for more details.
##
##  You should have received a copy of the GNU General Public License
##  along with this program. If not, see <http://www.gnu.org/licenses/>.
##
##  Copyright (C) 2016, Andrew McConachie, <andrew@depht.com>

## Globals and includes
rootLetters <- c("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m")
library(yaml, lib.loc=".") ## Tells R where to find the YAML lib
`%.%` <- function(a, b) paste0(a, b) ## Infix concatenation operator

## letters can be a single letter(a), a range(a-c), a list(a,b,g), or a combination of all 3
## letters MUST be given in order(e.g. a-d,f,l-m), white space is not allowed
## If letters is not a single letter, an aggregate will be returned
## startDate and endDate are inclusive and take the form YYYY/MM/DD
## metric matches the YAML filename and metric: attribute, it MUST be present, e.g. traffic-sizes
## submetrics matches 1 or more of the YAML subsubmetrics, it is optional and can be a string or vector, e.g. udp-request-sizes
## subsubbmetrics matches 1 or more of the YAML subsubmetrics, it is optional and can be a string or vector, e.g. 16-31
## All arguments are strings
rootData <- function(letters, startDate, endDate, metric, submetrics, subsubmetrics){
    if(missing(submetrics)){
        ## TODO:Do something
    }

    ## Generate our list of letters
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
    
    ##    cat(length(fileLetters), "\n")
    ##    cat(unlist(fileLetters), "\n")

    for(let in fileLetters){
        cat(let %.% "-root", "\n")
        activeDate <- unlist(strsplit(startDate, "/"))
        endDate <- unlist(strsplit(endDate, "/"))
        while(! all(activeDate == endDate)){
            ##cat(endDate, "\n")
            ##cat(activeDate, "\n")
            fn <- paste(let, "root", activeDate[1] %.% activeDate[2] %.% activeDate[3], metric, sep="-") %.% ".yaml"
            fp <- file.path(let %.% "-root", activeDate[1], activeDate[2], metric) %.% "/"
            f <- fp %.% fn
            cat(f,"\n")
            if(file.exists(f)){
                cat("exists:", "\n")
                cat(f,"\n")
                yam <- yaml.load_file(f)
                unlink(f)
                ## TODO:Do something with the yaml
            }
            activeDate <- incDate(activeDate)
        }
    }
}

## Increments a date vector
## Dirty, don't try this at home kids
incDate <- function(dat){
    pad <- function(s){
        if(nchar(s) < 2){
            return("0" %.% s)
        }else{
            return(s)
        }
    }

    if(as.integer(dat[3]) < 31){
        return(c(dat[1], dat[2], pad(as.integer(dat[3]) + 1)))
    }
    if(as.integer(dat[2]) < 12){
        quit()
        return(c(dat[1], pad(as.integer(dat[2]) + 1, "1")))
    }
    quit()
    return(c(as.integer(dat[1]) + 1, "1", "1"))
}

    
rootData('a',"2016/01/01","2016/02/01", "load-time")

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



