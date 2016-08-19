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

for(ii in seq(0, 272, by=16)){
    idx <- as.character(ii) %.% '-' %.% as.character(ii+15)
    vec <- metricsByDate('..', 'a','2016-01-01','2016-03-01', c('traffic-sizes', 'udp-request-sizes', as.character(idx)))
    if(ii == 0){
        queries <- data.frame('x0_15' = vec, check.names=FALSE)
    }else{
        queries[['x' %.% gsub('-', '_', idx)]] <- vec
    }
}
queries[['x288']] <- metricsByDate('..', 'a','2016-01-01','2016-03-01', c('traffic-sizes', 'udp-request-sizes', as.character('288-')))
queries[['dates']] <- seq(as.Date('2016-01-01'), by='days', along.with=queries[['x288']])

png(filename='ex10.png', width=1000, height=800)

## Maybe if I new R better my code wouldn't be so disgusting, but somehow I doubt it
ggplot(queries, aes(x=dates)) + labs(title = "UDP Requests by Size Ranges", x='Days', y='Requests log(n)', colour = 'Size Ranges') +
geom_line(aes(y=x0_15, colour='0-15')) + geom_line(aes(y=x32_47, colour='32-47')) + geom_line(aes(y=x48_63, colour='48-63')) +
    geom_line(aes(y=x64_79, colour='64-79')) + geom_line(aes(y=x80_95, colour='80-95')) + geom_line(aes(y=x96_111, colour='96-111')) +
        geom_line(aes(y=x112_127, colour='112-127')) + geom_line(aes(y=x128_143, colour='128-143')) + geom_line(aes(y=x144_159, colour='144-159')) +
            geom_line(aes(y=x160_175, colour='160-175')) + geom_line(aes(y=x176_191, colour='176-191')) + geom_line(aes(y=x192_207, colour='192-207')) +
                geom_line(aes(y=x208_223, colour='208-223')) + geom_line(aes(y=x224_239, colour='224-239')) + geom_line(aes(y=x240_255, colour='240-255')) +
                    geom_line(aes(y=x256_271, colour='256-271')) + geom_line(aes(y=x272_287, colour='272-287')) + geom_line(aes(y=x288, colour='288-')) +
                        scale_y_continuous(trans='log')

