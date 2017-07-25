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
##  Copyright (C) 2017, Andrew McConachie, <andrew@depht.com>
options(warn=1)
source('../rssac002.R') ## Include our RSSAC002 API
library(ggplot2) ## Our graphing library

letters <- 'A-M'
startDate <- '2017-05-01'
endDate <- '2017-06-01'

udpP <- unlist(perc(metricsByDate('..', letters, startDate, endDate, c('traffic-sizes', 'udp-response-sizes'))), use.names=FALSE)
udpP <- udpP[!udpP == 0]

sizes <- seq(8, by=16, along.with=udpP)
ticksX <- sizes[sizes %% 10 == 0]

udpF <- data.frame(perc=udpP, size=sizes)

png(filename='ex14.png', width=1000, height=800)
ggplot() + labs(title='UDP Response Packet Size in Bytes A-M \nMay 2017', y='% of Total', x='Bytes') +
    geom_line(data = udpF, aes(x = size, y=perc)) + scale_x_discrete(limits=ticksX)




