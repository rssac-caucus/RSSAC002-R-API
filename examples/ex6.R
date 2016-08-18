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

A <- metricsByDate('..', 'a','2016-01-01','2016-01-02', c('traffic-sizes', 'udp-response-sizes'))
K <- metricsByDate('..', 'k','2016-01-01','2016-01-02', c('traffic-sizes', 'udp-response-sizes'))

startSizes <- 3
endSizes <- 19

sizes <- data.frame(labels=names(A[startSizes:endSizes]), a=unlist(A[startSizes:endSizes]), k=unlist(K[startSizes:endSizes]))
levels(sizes$labels) <- c(names(A[startSizes:endSizes])) ## Orders our bar graph by size ranges

png(filename='ex6.png', width=1000, height=800)
ggplot(sizes, aes(labels)) + labs(title = "Count of UDP Response Packets by Size", x="Sizes", y="Count Packets", colour = 'Root') +
    geom_bar(stat='identity', aes(y=a, colour='A Root')) + 
        geom_bar(stat='identity', aes(y=k, colour='K Root'))