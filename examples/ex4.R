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

startDate <- '2016-01-01'
endDate <- '2016-07-01'

A4 <- metricsByDate('..', 'a', startDate, endDate, c('unique-sources', 'num-sources-ipv4'))
A6 <- metricsByDate('..', 'a', startDate, endDate, c('unique-sources', 'num-sources-ipv6'))

C4 <- metricsByDate('..', 'c', startDate, endDate, c('unique-sources', 'num-sources-ipv4'))
C6 <- metricsByDate('..', 'c', startDate, endDate, c('unique-sources', 'num-sources-ipv6'))

D4 <- metricsByDate('..', 'd', startDate, endDate, c('unique-sources', 'num-sources-ipv4'))
D6 <- metricsByDate('..', 'd', startDate, endDate, c('unique-sources', 'num-sources-ipv6'))

Agg4 <- metricsByDate('..', 'a,c,d,h,j-m', startDate, endDate, c('unique-sources', 'num-sources-ipv4'))
Agg6 <- metricsByDate('..', 'a,c,d,h,j-m', startDate, endDate, c('unique-sources', 'num-sources-ipv6'))

days <- seq(as.Date(startDate), by='days', along.with=A4)

A <- A6 / (A4+A6) * 100
C <- C6 / (C4+C6) * 100
D <- D6 / (D4+D6) * 100
Agg <- Agg6 / (Agg4+Agg6) * 100

lets <- data.frame(dates=days, Agg=Agg, A=A, C=C, D=D)
png(filename='ex4.png', width=1200, height=800)

pv <- 0.1 ## Width of ribbon
ggplot() + labs(title='% IPv6 Sources Seen', y='%', x='2016', colour = 'Root') +
    geom_ribbon(data = lets, aes(x = dates, y=Agg, ymax=Agg+pv, ymin=Agg-pv, colour='A,C,D,H,J,K,L,M')) +
        geom_ribbon(data = lets, aes(x = dates, y=A, ymax=A+pv, ymin=A-pv, colour='A')) +
            geom_ribbon(data = lets, aes(x = dates, y=C, ymax=C+pv, ymin=C-pv, colour='C')) +
                geom_ribbon(data = lets, aes(x = dates, y=D, ymax=D+pv, ymin=D-pv, colour='D'))

