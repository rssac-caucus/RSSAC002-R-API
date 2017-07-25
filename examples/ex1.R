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

ip6_sources_j <- metricsByDate('..', 'j','2016-01-01','2017-01-01', c('unique-sources', 'num-sources-ipv6-aggregate'))
ip6_sources_l <- metricsByDate('..', 'l','2016-01-01','2017-01-01', c('unique-sources', 'num-sources-ipv6-aggregate'))

days <- seq(as.Date('2016-01-01'), by='days', along.with=ip6_sources_j)

dj <- data.frame(let=ip6_sources_j, dates=days)
dl <- data.frame(let=ip6_sources_l, dates=days)

png(filename='ex1.png', bg='white', width=1000, height=800)
ggplot() +  labs(title = 'IPv6 /64 Networks Seen Time series', x='2016', y='IPv6 /64 Networks', colour = 'Root') +
    geom_point(data = dj, aes(x = days, y=let, colour='J')) + geom_point(data = dl, aes(x = days, y = let, colour='L'))

