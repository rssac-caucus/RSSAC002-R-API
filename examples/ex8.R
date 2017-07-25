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

letters <- 'a,c,d,h,j-m'
startDate <- '2016-01-01'
endDate <- '2017-01-01'

U4 <- metricsByDate('..', letters, startDate, endDate, c('traffic-volume', 'dns-udp-queries-received-ipv4'))
U6 <- metricsByDate('..', letters, startDate, endDate, c('traffic-volume', 'dns-udp-queries-received-ipv6'))
T4 <- metricsByDate('..', letters, startDate, endDate, c('traffic-volume', 'dns-tcp-queries-received-ipv4'))
T6 <- metricsByDate('..', letters, startDate, endDate, c('traffic-volume', 'dns-tcp-queries-received-ipv6'))

days <- seq(as.Date(startDate), by='days', along.with=U4)
queries <- data.frame(dates=days, udp4=U4, udp6=U6, tcp4=T4, tcp6=T6)

png(filename='ex8.png', width=1000, height=800)

ggplot(queries, aes(x=dates)) + labs(title = "DNS Requests \n A, C, D, H, J, K, L, M", x='2016', y='Requests log(n)', colour='') +
    geom_line(aes(y=udp4, colour='UDP IPv4')) + geom_line(aes(y=tcp4, colour='TCP IPv4')) +
        geom_line(aes(y=udp6, colour='UDP IPv6')) + geom_line(aes(y=tcp6, colour='TCP IPv6')) +
            scale_y_continuous(trans='log', breaks = scales::trans_breaks("log10", function(x) 10^x),
                               labels=scales::trans_format("log10", scales::math_format(10^.x)))
    
