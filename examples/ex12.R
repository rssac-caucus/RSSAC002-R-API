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
endDate <- '2016-07-01'

letters <- list('A', 'C', 'D', 'H', 'J', 'K', 'L', 'M')
metrics <- list('dns-udp-queries-received-ipv4', 'dns-udp-queries-received-ipv6', 'dns-tcp-queries-received-ipv4', 'dns-tcp-queries-received-ipv6',
                'dns-udp-responses-sent-ipv4', 'dns-udp-responses-sent-ipv6', 'dns-tcp-responses-sent-ipv4', 'dns-tcp-responses-sent-ipv6')
labels <- list('IPv4 UDP Queries', 'IPv6 UDP Queries', 'IPv4 TCP Queries', 'IPv6 TCP Queries', 'IPv4 UDP Responses', 'IPv6 UDP Responses',
               'IPv4 TCP Reponses', 'IPv6 TCP Responses')

## Init some vars
lets <- list()
lets[['agg']] <- list()
for(ll in labels){
    lets[['agg']][[ll]] <- 0
}

## Get values
for(let in letters){
    lets[[let]] <- list()
    for(ii in 1:length(metrics)){
        lets[[let]][[labels[[ii]]]] <- sum(metricsByDate('..', let, startDate, endDate, c('traffic-volume', metrics[[ii]])), na.rm=TRUE)
        lets[['agg']][[labels[[ii]]]] <- lets[['agg']][[labels[[ii]]]] + lets[[let]][[labels[[ii]]]]
    }
}

## Compute percents
for(let in letters){
    for(ii in 1:length(metrics)){
        lets[[let]][[labels[[ii]]]] <- round(lets[[let]][[labels[[ii]]]] / lets[['agg']][[labels[[ii]]]] * 100, digits=2)
    }
}

## Draw stuff
packets <- melt(data.frame(labels=names(lets[['A']]), A=unlist(lets[['A']]), C=unlist(lets[['C']]), D=unlist(lets[['D']]), H=unlist(lets[['H']]), J=unlist(lets[['J']]),
                           K=unlist(lets[['K']]), L=unlist(lets[['L']]), M=unlist(lets[['M']])), id='labels', variable.name='Root')

png(filename='ex12.png', width=1000, height=800)
ggplot(packets, aes(x=labels, y=value, fill=Root)) +
    labs(title = 'Traffic Volume Percentages by Root January - June 2016\n ' %.% paste(letters, collapse=','), x="", y="%") +
        geom_bar(stat='identity', position='stack')

