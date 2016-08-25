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
letters <- 'A, H, J, K, L, M'
agg <- maxN(metricsByDate('..', letters, startDate, endDate, c('traffic-sizes', 'udp-response-sizes')), 10)

ranges <- sapply(names(agg),
                       function(x) metricsByDate('..', letters, startDate, endDate, c('traffic-sizes', 'udp-response-sizes', x)), simplify=FALSE)
df <- melt(data.frame(dates=seq(as.Date(startDate), by='days', along.with=ranges[[1]]), ranges, check.names=FALSE), id='dates', variable.name='Ranges')

png(filename='ex11.png', width=1000, height=800)
ggplot(df, aes(x=dates, y=value, colour=Ranges)) + labs(title = "Timeseries of top 10 UDP Responses \n A,H,J,K,L,M", x="2016", y="Count Packets", colour="Range") +
    geom_line(size=2) + scale_y_continuous(trans='log10', breaks = scales::trans_breaks("log10", function(x) 10^x),
                      labels=scales::trans_format("log10", scales::math_format(10^.x)))

