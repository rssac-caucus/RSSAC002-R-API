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

startDate <- '2016-01-01'
endDate <- '2017-01-01'
agg <- maxN(perc(metricsByDate('..', 'A, H, J, K, L, M', startDate, endDate, c('traffic-sizes', 'udp-response-sizes'))), 10)

## Grab same metrics as what's in agg for each letter
lets <- list()
for(let in list('A', 'H', 'J', 'K', 'L', 'M')){
    lets[[let]] <- list()
    tmp <- perc(metricsByDate('..', let, startDate, endDate, c('traffic-sizes', 'udp-response-sizes')))
    for(key in names(agg)){
        lets[[let]][[key]] <- tmp[[key]]
    }
}

sizes <- melt(data.frame(labels=names(agg), Aggregate=unlist(agg), A=unlist(lets[['A']]), H=unlist(lets[['H']]), J=unlist(lets[['J']]),
                     K=unlist(lets[['K']]), L=unlist(lets[['L']]), M=unlist(lets[['M']])), id='labels', variable.name='Root')

png(filename='ex6.png', width=1500, height=800)
ggplot(sizes, aes(x=labels, y=value, fill=Root)) +
    labs(title = "Top 10 Aggregate UDP Response Sizes by root \n 2016", x="Packet Size Range", y="% of all UDP responses") +
        geom_bar(stat='identity', position='dodge') + scale_x_discrete(limits=unlist(names(agg)))

