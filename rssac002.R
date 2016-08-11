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
.libPaths(".")
suppressPackageStartupMessages(library("methods"))
library(yaml) ##  Read/write YAML files
library(ggplot2) ## Extended graphing options

`%.%` <- function(a, b) paste0(a, b) ## Infix concatenation operator
rootLetters <- c("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m")

## letters can be a single letter(a), a range(a-c), a list(a,b,g), or a combination of all 3
## letters MUST be given in order(e.g. a-d,f,l-m), white space is not allowed
## If letters is not a single letter, an aggregate will be returned
##
## startDate and endDate take the form YYYY/MM/DD, endDate will not be included
## Invalid DD values can be used for endDate if(DD < 32) Example: 2016/02/30
##
## metrics is a vector of requested metrics as strings arranged in a hierarchy to identify a single vector of values
## The first and second entry of metrics are required
## The following entries of metrics are optional dependent on the metric being queried
## Examples: c("traffic-sizes", "udp-request-sizes", "16-31"), c("unique-sources", "num-sources-ipv6"), 
## c("rcode-volume", "10"), 
##
## Returns a vector of values ordered by date
metricsByDate <- function(letters, startDate, endDate, metrics){
    ## Encapsulates mess of integer vs double(float)
    ## http://r.789695.n4.nabble.com/large-integers-in-R-td1310933.html
    setVal <- function(val){
        if(length(val) == 0){
            cat("setVal passed zero length value", "\n")
            return(as.integer(0))
        }

        if(as.integer(val) < 0){
            return(as.double(val))
        }else{
            return(as.integer(val))
        }
    }

    fmt <- "%Y/%m/%d" ## Our date format
    excludeYamlKeys <- c("service", "start-period", "end-period", "metric") ## Top-level YAML keys to never return
    rv <- list() ## Our return values
    fileLetters <- c() ## Our list of letters to work on

    ## TODO: Do some bad input checking and print errors and exit
    
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
    for(let in fileLetters){
        rv[let] <- c()
        activeDate <- unlist(strsplit(startDate, "/"))
        endDate <- unlist(strsplit(endDate, "/"))
        while(! all(activeDate == endDate)){
            ##cat("Parsing " %.% let %.% "-root", "\n")
            fn <- paste(let, "root", activeDate[1] %.% activeDate[2] %.% activeDate[3], metrics[1], sep="-") %.% ".yaml"
            fp <- file.path(let %.% "-root", activeDate[1], activeDate[2], metrics[1]) %.% "/"
            f <- fp %.% fn
            if(file.exists(f)){
                ##cat("exists  " %.% f, "\n")
                yamtmp <- yaml.load_file(f)
                yam <- list()
                for(ii in 1:length(yamtmp)){ ## Remove excluded keys from yaml
                    if(! names(yamtmp[ii]) %in% excludeYamlKeys){
                        yam[[names(yamtmp[ii])]] <- yamtmp[ii]
                    }
                }

                if(length(metrics) == 2){
                    rv[[let]] <- append(rv[[let]], setVal(yam[[metrics[2]]]))
                }else{
                    rv[[let]] <- append(rv[[let]], setVal(yam[metrics[2]][[1]][[1]][[metrics[3]]]))
                }
            }else{ ## No file for this date, fill with zero
                cat("Missing " %.% f, "\n")
                rv[[let]] <- append(rv[[let]], 0)
            }
            ## Increment activeDate
            activeDate <- unlist(strsplit(format(as.Date(paste(activeDate, collapse="/"), fmt) + 1, fmt), "/"))
        }
    }

    ## Compute aggregate
    agg = c(0)
    for(let in fileLetters){
        agg <- agg + rv[[let]]
    }
    return(agg)
}