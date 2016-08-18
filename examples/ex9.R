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

A4 <- metricsByDate('..', 'a','2016-01-01','2016-07-01', c('unique-sources', 'num-sources-ipv4'))
A6 <- metricsByDate('..', 'a','2016-01-01','2016-07-01', c('unique-sources', 'num-sources-ipv6'))
A6agg <- metricsByDate('..', 'a','2016-01-01','2016-07-01', c('unique-sources', 'num-sources-ipv6-aggregate'))

days <- seq(as.Date('2016-01-01'), by='days', along.with=A4)

sources <- data.frame(dates=days, ip4=A4, ip6=A6, ip6agg=A6agg)

png(filename='ex9.png', width=1000, height=800)

ggplot(sources, aes(x=dates, colour="IP Source Type")) + labs(title = "IP Sources Seen", x='Days', y='Source Addresses log(n)') +
    geom_line(aes(y=ip4, colour='IPv4')) + geom_line(aes(y=ip6, colour='IPv6')) +
        geom_line(aes(y=ip6agg, colour='IPv6 Aggregate /64')) +
            scale_y_continuous(trans='log')

    
