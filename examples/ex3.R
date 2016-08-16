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

A4 <- metricsByDate('..', 'a', '2016-01-01','2016-07-01', c('unique-sources', 'num-sources-ipv4'))
A6 <- metricsByDate('..', 'a', '2016-01-01','2016-07-01', c('unique-sources', 'num-sources-ipv6'))

C4 <- metricsByDate('..', 'c', '2016-01-01','2016-07-01', c('unique-sources', 'num-sources-ipv4'))
C6 <- metricsByDate('..', 'c', '2016-01-01','2016-07-01', c('unique-sources', 'num-sources-ipv6'))

D4 <- metricsByDate('..', 'd', '2016-01-01','2016-07-01', c('unique-sources', 'num-sources-ipv4'))
D6 <- metricsByDate('..', 'd', '2016-01-01','2016-07-01', c('unique-sources', 'num-sources-ipv6'))

Agg4 <- metricsByDate('..', 'a,c,d,h,j-m', '2016-01-01','2016-07-01', c('unique-sources', 'num-sources-ipv4'))
Agg6 <- metricsByDate('..', 'a,c,d,h,j-m', '2016-01-01','2016-07-01', c('unique-sources', 'num-sources-ipv6'))

days <- seq(as.Date('2016-01-01'), by='days', along.with=A4)

A <- A6 / (A4+A6) * 100
C <- C6 / (C4+C6) * 100
D <- D6 / (D4+D6) * 100
Agg <- Agg6 / (Agg4+Agg6) * 100

lets <- data.frame(dates=days, A=A, C=C, D=D, Agg=Agg)

png(filename='ex3.png', width=1000, height=800)

ggplot(lets, aes(Agg)) + labs(title='Density of Aggregate IPv6 Sources', y='Density', x='% IPv6 Sources Seen') +
    geom_density()

