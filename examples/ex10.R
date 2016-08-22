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
library(reshape2) ## Allows data melting

mvec <- list()
for(ii in seq(0, 272, by=16)){
    idx <- as.character(ii) %.% '-' %.% as.character(ii+15)
    vec <- metricsByDate('..', 'A, H, J, K, L, M','2016-01-01','2016-07-01', c('traffic-sizes', 'udp-request-sizes', as.character(idx)))
    ## mvec[[idx]] <- mean(vec, na.rm=TRUE) ## We might want to order these later, once we figure out how

    if(ii == 0){
        queries <- data.frame('0-15' = vec, check.names=FALSE)
    }else{
        queries[[idx]] <- vec
    }
}
queries[['288+']] <- metricsByDate('..', 'A, H, J, K, L, M','2016-01-01','2016-07-01', c('traffic-sizes', 'udp-request-sizes', as.character('288-')))
queries[['dates']] <- seq(as.Date('2016-01-01'), by='days', along.with=queries[['288+']])

png(filename='ex10.png', width=1000, height=800)

ggplot(data=melt(queries, id="dates") , aes(x=dates, y=value, colour=variable)) +
    labs(title = 'Timeseries of UDP Requests by Byte Size \n A, H, J, K, L, M', x='Days', y='Requests log(n)', colour = 'Size Ranges') +
        geom_line() + scale_y_continuous(trans='log')


