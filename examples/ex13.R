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
options(warn=1)
suppressPackageStartupMessages(library("methods"))
.libPaths(c(.libPaths(), "../"))
source('../rssac002.R') ## Include our RSSAC002 API
library(ggplot2) ## Our graphing library
library(reshape2)

letters <- list('A', 'J')
startDate <- '2016-01-01'
endDate <- '2017-01-01'

codes <- as.list(as.character(seq(0, 16)))

## Init some vars
lets <- list()
lets[['agg']] <- list()
for(ll in codes){
    lets[['agg']][[ll]] <- 0
}

## Get values
for(let in letters){
    lets[[let]] <- list()
    for(ii in 1:length(codes)){
        lets[[let]][[codes[[ii]]]] <- sum(metricsByDate('..', let, startDate, endDate, c('rcode-volume', codes[[ii]])), na.rm=TRUE)
        lets[['agg']][[codes[[ii]]]] <- lets[['agg']][[codes[[ii]]]] + lets[[let]][[codes[[ii]]]]
    }
}

## Compute percents
for(let in letters){
    for(ii in 1:length(codes)){
        lets[[let]][[codes[[ii]]]] <- round(lets[[let]][[codes[[ii]]]] / lets[['agg']][[codes[[ii]]]] * 100, digits=2)
    }
}

## Draw stuff
rcodes <- melt(data.frame(labels=names(lets[['A']]), A=unlist(lets[['A']]), J=unlist(lets[['J']])), id='labels', variable.name='Root')

png(filename='ex13.png', width=1000, height=800)
ggplot(rcodes, aes(x=labels, y=value, fill=Root)) +
    labs(title = 'Rcode Volume Percentages by Root 2016\n ' %.% paste(letters, collapse=','), x="", y="%") +
        geom_bar(stat='identity', position='stack') + scale_x_discrete(limits=unlist(codes))

