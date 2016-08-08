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
options(warn=1)
rootLetters <- c("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m")
library(yaml, lib.loc=".") ## Tells R where to find the YAML lib
`%.%` <- function(a, b) paste0(a, b) ## Infix concatenation operator

## letters can be a single letter(a), a range(a-c), a list(a,b,g), or a combination of all 3
## letters MUST be given in order(e.g. a-d,f,l-m), white space is not allowed
## If letters is not a single letter, an aggregate will be returned
## startDate and endDate are inclusive and take the form YYYY/MM/DD
## metrics is a vector of requested metrics arranged in a hierarchy
## The first entry of metrics is required, and can only be a string of the top-level metric/directory name
## The following entries of metrics are optional, and can be either a string metric name or vector of string metric names
## Examples: c("traffic-sizes", "udp-request-sizes", "16-31")
## Other entries in metrics can be vectors containing metrics, c("traffic-sizes", "udp-request-sizes", c("16-31", "32-47"))
## Or left empty to return all entries at that level, c("traffic-sizes", "udp-request-sizes"), c("rcode-volume") 
metricsByDate <- function(letters, startDate, endDate, metrics){
    excludeYamlKeys <- c("service", "start-period", "end-period", "metric") ## Top-level YAML keys to never return
    rv <- list()
    fileLetters <- c() ## Our list of letters to work on

    ## Generate our list of letters
    letters <- tolower(letters)
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

    ## Read files from disk and fill rv
    activeDate <- unlist(strsplit(startDate, "/"))
    endDate <- unlist(strsplit(endDate, "/"))
    while(! all(activeDate == endDate)){
        rv[[length(rv)+1]] <- list(date=activeDate, letters=list())
        str(rv)
        for(let in fileLetters){
            cat("Parsing " %.% let %.% "-root", "\n")
            fn <- paste(let, "root", activeDate[1] %.% activeDate[2] %.% activeDate[3], metrics[1], sep="-") %.% ".yaml"
            fp <- file.path(let %.% "-root", activeDate[1], activeDate[2], metrics[1]) %.% "/"
            f <- fp %.% fn
            ##cat(f, "\n")
            if(file.exists(f)){
                cat(f %.% " exists:", "\n")
                yam <- yaml.load_file(f)
                rv[[length(rv)]][['letters']][[let]] <- append(rv[[length(rv)]][[letters]], let=list()
                if(length(metrics) == 1){
                    for(ii in 1:length(yam)){
                        if(! names(yam[ii]) %in% excludeYamlKeys){
                            str(rv)
                            rv[[length(rv)+1]][[date]][[let]] <- list(service=let)  ##names(yam[ii])=yam[ii])
                            str(rv)
                            ##cat(names(yam[ii]) %.% ":" %.% yam[ii], "\n")
                        }
                    }
                }
            }
            activeDate <- incDate(activeDate)
        }
    }
    return(rv)

    ## We want to convert all dates to R dates before returning
    ##as.Date(paste(activeDate, collapse="/"), "%Y/%m/%d"), list())
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
        return(c(dat[1], pad(as.integer(dat[2]) + 1, "1")))
    }
    return(c(as.integer(dat[1]) + 1, "1", "1"))
}

## Push a value on to the end of a vector, why is this not built in?
##push <- function(vec, val){ return(c(vec, value)) }
        
met <- metricsByDate('a',"2016/01/01","2016/01/02", c("rcode-volume"))

##cat(str(met))

##png(filename="figure.png", height=295, width=300, bg="white")

##plot(met)

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





## Create box around plot
##box()

## Turn off device driver (to flush output to png)
##dev.off()



