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
source('../rssac002.R') ## Include our RSSAC002 API
library(ggplot2) ## Our graphing library

agg <- maxN(metricsByDate('..', 'A, H, J, K, L, M','2016-01-01','2017-01-10', c('traffic-sizes', 'udp-response-sizes')), 20)

sizes <- data.frame(labels=names(agg), vals=unlist(agg))

png(filename='ex7.png', width=1000, height=800)
ggplot(sizes, aes(labels)) + labs(title = "20 Most Common UDP Response Packet Sizes, 2016 \n A,H,J,K,L,M", x='', y='') +
    geom_bar(stat='identity', aes(y=vals)) + coord_polar() + scale_x_discrete(limits=unlist(names(agg)))

