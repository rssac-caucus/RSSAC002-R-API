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
.libPaths(c(.libPaths(), "."))
suppressPackageStartupMessages(library("methods"))
library(yaml) ##  Read/write YAML files

`%.%` <- function(a, b) paste0(a, b) ## Infix concatenation operator
rootLetters <- c("a", "b", "c", "d", "e", "h", "j", "k", "l", "m")

## path is the relative or absolute location of the rssac002 data files
##
## letters can be a single letter(a), a range(a-c), a list(a,b,g), or a combination of all 3
## letters is case inspecific
## If letters is not a single letter, an aggregate will be returned
##
## startDate and endDate take the form YYYY-MM-DD, endDate will not be included
## Example: 2016-02-30
##
## metrics is a vector of requested metrics as strings arranged in a hierarchy to identify a single vector of values
## The first and second entry of metrics are required
## The following entries of metrics are optional dependent on the metric being queried
## Examples: c("traffic-sizes", "udp-request-sizes", "16-31"), c("unique-sources", "num-sources-ipv6"), 
## c("rcode-volume", "10"), 
##
## metricsByDate() Returns a vector of values ordered by date
##
## Special-case traffic-sizes
## If metricsBydate(path, letters, startDate, endDate, c('traffic-sizes', $SIZE_TYPE))
## Where $SIZE_METRIC == 'udp-request-sizes' || 'udp-response-sizes' || 'tcp-request-sizes' || 'tcp-response-sizes'
## metricsByDate will return a 2 dimensional list of all sizes of $SIZE_TYPE by date
metricsByDate <- function(path, letters, startDate, endDate, metrics){
    ## Encapsulates mess of integer vs double
    ## We store everything as double because RAM is cheap
    ## http://r.789695.n4.nabble.com/large-integers-in-R-td1310933.html
    setVal <- function(val){
        if(length(val) == 0){
            ##cat("setVal passed zero length value", "\n")
            return(as.integer(0))
        }
        return(as.double(unlist(val)))
    }

    fmt <- "%Y-%m-%d" ## Our date format
    excludeYamlKeys <- c("service", "start-period", "end-period", "metric") ## Top-level YAML keys to never return
    rv <- list() ## Our return values
    fileLetters <- c() ## Our list of letters to work on

    ## Bad input checking, print errors and exit
    if(! substr(path, nchar(path), nchar(path)) == '/') { path <- path %.% '/' } ## Append / to path if necessary
    if(! (length(metrics) != 2 || length(metrics) != 3)){
        cat("Bad length of metrics argument len=" %.% length(metrics), "\n")
        quit()
    }
    tryCatch({
        as.Date(startDate)
        as.Date(endDate)
    }, error=function(e){
        cat("Bad or nonexistent date", "\n")
        quit()
    })
    if(as.Date(startDate) > as.Date(endDate)){
        cat("Start date comes after end date", "\n")
        quit()
    }
    if(as.Date(startDate) == as.Date(endDate)){
        cat("Start date and end date same", "\n")
        quit()
    }

    ## Determine what type of return value we're producing
    ## A collection of special cases
    rvType = 'vector'
    if(length(metrics) == 2){
        if(metrics[1] == 'traffic-sizes'){ ## Special case traffic-sizes
            rvType = 'list'
        }
    }

    ## Generate our list of letters
    letters <- sort(gsub(' ', '', tolower(letters)))
    toks <- unlist(strsplit(letters, ""))
    ii <- 0
    for(t in toks){
        if(! (t %in% rootLetters || t == ',' || t == '-')){
            cat("Bad character in letters argument: " %.% t, "\n")
            quit()
        }
    }
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
        if(rvType == 'vector') { rv[let] <- c() }
        else if(rvType == 'list') { rv[[let]] <- list() }
        activeDate <- unlist(strsplit(startDate, "-"))
        endDate <- unlist(strsplit(endDate, "-"))
        while(! all(activeDate == endDate)){
            ##cat("Parsing " %.% let %.% "-root", "\n")
            fn <- paste(let, "root", activeDate[1] %.% activeDate[2] %.% activeDate[3], metrics[1], sep="-") %.% ".yaml"
            fp <- file.path(path %.% let %.% "-root", activeDate[1], activeDate[2], metrics[1]) %.% "/"
            f <- fp %.% fn
            if(file.exists(f)){
                ##cat("exists  " %.% f, "\n")
                yamtmp <- yaml.load_file(f, handlers=list(int=function(x) { as.double(x) })) ## Interpret integers as doubles
                yam <- list()
                for(ii in 1:length(yamtmp)){ ## Remove excluded keys from yaml
                    if(! names(yamtmp[ii]) %in% excludeYamlKeys){
                        yam[[names(yamtmp[ii])]] <- yamtmp[ii]
                    }
                }

                if(length(metrics) == 2){
                    if(metrics[1] == 'traffic-sizes'){ ## Special case traffic-sizes, possibly can make more general
                        for(ii in 1:length(yam[metrics[[2]]][[1]][[1]] )){ ## List indices? More like list indecents
                            key <- names(yam[metrics[2]][[1]][[1]][ii])
                            value <- yam[metrics[2]][[1]][[1]][ii][[1]]
                            if(key %in% names(rv[[let]])){
                                rv[[let]][[key]] <- rv[[let]][[key]] + setVal(value)
                            }else{
                                ##cat("let:" %.% let %.% " key:" %.% key %.% " val:" %.% as.double(value), "\n")
                                rv[[let]][[key]] <- setVal(value)
                            }
                        }
                    }else{
                        rv[[let]] <- append(rv[[let]], setVal(yam[[metrics[2]]]))
                    }
                }else{
                    rv[[let]] <- append(rv[[let]], setVal(yam[metrics[2]][[1]][[1]][[metrics[3]]]))
                }
            }else{ ## No file for this date, fill with Not-a-Number(NaN) and warn user
                cat("Warn:Missing " %.% f, "\n")
                if(rvType == 'vector'){
                    rv[[let]] <- append(rv[[let]], NaN)
                }
            }
            ## Increment activeDate
            activeDate <- unlist(strsplit(format(as.Date(paste(activeDate, collapse="-"), fmt) + 1, fmt), "-"))
        }
    }

    ## Compute aggregate and return
    if(rvType == 'list'){
        agg <- list()
        for(let in fileLetters){
            for(key in names(rv[[let]])){
                if(key %in% names(agg)){
                    agg[[key]] <- as.double(agg[[key]]) + as.double(rv[[let]][[key]])
                }else{
                    agg[[key]] <- as.double(rv[[let]][[key]])
                }
            }
        }
    }else if(rvType == 'vector'){
        agg = c(0)
        for(let in fileLetters){
            agg <- agg + rv[[let]]
        }
    }
    return(agg)
}

## Return N most maximum values from a list preserving names and order
## ll is a list
## N is number of elements to return
maxN <- function(ll, N){ 
    while(length(ll) > N){ ll[[names(which.min(ll))]] <- NULL }
    return(ll)
}

## Compute percentage of total for each value in a list preserving names and order
## ll is a list of numeric values
## r is passed to round() as digits=r
perc <- function(ll, r=2){
    tot <- sum(unlist(ll))
    sapply(ll, function(x) round((x / tot) * 100, digits=r), simplify=FALSE)
}

