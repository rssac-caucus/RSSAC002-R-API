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

udp16 <- metricsByDate('..', 'A, H, J, K, L, M','2016-01-01','2016-07-01', c('traffic-sizes', 'udp-response-sizes', '16-31'))
days <- seq(as.Date('2016-01-01'), by='days', along.with=udp16)

responses <- data.frame(dates=days, udpAgg=udp16)

png(filename='ex11.png', width=1000, height=800)
ggplot(responses, aes(days)) + labs(title = "Timeseries of UDP Responses Sized 16-31 bytes \n A,H,J,K,L,M", x="2016", y="Count Packets") +
    geom_line(aes(y=udpAgg)) + scale_y_continuous(breaks = round(seq(0, max(responses$udpAgg, na.rm=TRUE), by = 10000000)))


