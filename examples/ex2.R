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

ip4 <- metricsByDate('..', 'a,c,d,h-m', '2016-01-01','2016-07-01', c('unique-sources', 'num-sources-ipv4'))
ip6 <- metricsByDate('..', 'a,c,d,h-m', '2016-01-01','2016-07-01', c('unique-sources', 'num-sources-ipv6'))
days <- seq(as.Date('2016-01-01'), by='days', along.with=ip4)

d <-  data.frame(ipv6=ip6 / (ip4+ip6) * 100, dates=days)

png(filename='ex2.png', bg='white', width=1000, height=800)
ggplot() + geom_ribbon(data = d, aes(x = days, y=ipv6, ymax=ipv6+0.1, ymin=ipv6-0.1)) +
    labs(title='% IPv6 Sources Seen \n A,C,D,H,J,K,L,M', y='%', x='2016')
