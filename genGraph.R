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
library(yaml, lib.loc=".") ##  Read/write YAML files
library(ggplot2, lib.loc=".") ## Extended graphing options
`%.%` <- function(a, b) paste0(a, b) ## Infix concatenation operator

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
            return(c(dat[1], pad(as.integer(dat[2]) + 1), "01"))
        }
        return(c(as.integer(dat[1]) + 1, "01", "01"))
    }
    
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


    excludeYamlKeys <- c("service", "start-period", "end-period", "metric") ## Top-level YAML keys to never return
    rv <- list()
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
                ##cat(f %.% " exists:", "\n")
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
            }
            activeDate <- incDate(activeDate)
        }
    }

    ## Compute aggregate
    agg = c(0)
    for(let in fileLetters){
        agg <- agg + rv[[let]]
    }
    return(agg)
}

##met <- metricsByDate('a',"2016/01/01","2016/01/20", c("unique-sources", "num-sources-ipv6"))
##met <- metricsByDate('a',"2016/01/01","2016/01/26", c("traffic-sizes", "udp-response-sizes", "192-207"))
##met <- metricsByDate('a-b',"2016/01/01","2016/01/20", c("traffic-volume", "dns-tcp-queries-received-ipv4"))
##met <- metricsByDate('a,j',"2016/01/01","2016/01/20", c("rcode-volume", "0"))
##met <- metricsByDate('a',"2016/01/01","2016/01/20", c("load-time", "2016011000"))


ip6_sources <- metricsByDate('a',"2016/01/01","2016/07/01", c("unique-sources", "num-sources-ipv6-aggregate"))



png(filename="figure.png", bg="white")
plot(ip6_sources)

## Turn off device driver (to flush output to png)
dev.off()

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




