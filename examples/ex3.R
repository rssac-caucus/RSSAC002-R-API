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

Agg4 <- metricsByDate('..', 'a,c,d,h,j-m', '2016-01-01','2017-01-01', c('unique-sources', 'num-sources-ipv4'))
Agg6 <- metricsByDate('..', 'a,c,d,h,j-m', '2016-01-01','2017-01-01', c('unique-sources', 'num-sources-ipv6'))
Agg <- Agg6 / (Agg4+Agg6) * 100
days <- seq(as.Date('2016-01-01'), by='days', along.with=Agg4)

sources <- data.frame(dates=days, Agg=Agg)

png(filename='ex3.png', width=1000, height=800)
ggplot(sources, aes(Agg)) + labs(title='Density of Percentage IPv6 Sources 2016 \n A,C,D,H,J,K,L,M', y='Density', x='% IPv6 Sources Seen') +
    geom_density()

