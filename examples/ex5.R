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
endDate <- '2017-01-01'

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

lets <- data.frame(dates=days, A=A, C=C, D=D, Agg=Agg)

png(filename='ex5.png', width=1000, height=800)

ggplot() + labs(title='% IPv6 Sources Seen', y='%', x='2016', colour = 'Root') +
    geom_point(data=lets, aes(x=dates, y=Agg, colour='A,C,D,H,J,K,L,M')) + geom_smooth(data=lets, aes(x=dates, y=Agg), method = 'lm', se = FALSE) +
        geom_point(data=lets, aes(x=dates, y=A, colour='A')) + geom_smooth(data=lets, aes(x=dates, y=A), method = 'lm', se = FALSE) +
            geom_point(data=lets, aes(x=dates, y=C, colour='C')) + geom_smooth(data=lets, aes(x=dates, y=C), method = 'lm', se = FALSE) +
                geom_point(data=lets, aes(x=dates, y=D, colour='D')) + geom_smooth(data=lets, aes(x=dates, y=D), method = 'lm', se = FALSE)
