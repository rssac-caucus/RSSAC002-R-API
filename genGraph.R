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

source('rssac002.R') ## Include our RSSAC002 API

##met <- metricsByDate('a','2016/01/01','2016/01/20', c('unique-sources', 'num-sources-ipv6'))
##met <- metricsByDate('a','2016/01/01','2016/01/26', c('traffic-sizes', 'udp-response-sizes', '192-207'))
##met <- metricsByDate('a-b','2016/01/01','2016/01/20', c('traffic-volume', 'dns-tcp-queries-received-ipv4'))
##met <- metricsByDate('a,j','2016/01/01','2016/01/20', c('rcode-volume', '0'))
##met <- metricsByDate('a','2016/01/01','2016/01/20', c('load-time', '2016011000'))

days <- seq(as.Date('2016/01/01', '%Y/%m/%d'), len=182, by='1 day')

example <- "
ip6_sources_j <- metricsByDate('j','2016/01/01','2016/07/01', c('unique-sources', 'num-sources-ipv6-aggregate'))
ip6_sources_l <- metricsByDate('l','2016/01/01','2016/07/01', c('unique-sources', 'num-sources-ipv6-aggregate'))

dj <- data.frame(let=ip6_sources_j, dates=days)
dl <- data.frame(let=ip6_sources_l, dates=days)

png(filename='test.png', bg='white')
ggplot() + geom_point(data = dj, aes(x = days, y=let)) + geom_point(data = dl, aes(x = days, y = let), colour = 'red')
"

example <- "
ip4 <- metricsByDate('a,c,d,h-m', '2016/01/01','2016/07/01', c('unique-sources', 'num-sources-ipv4'))
ip6 <- metricsByDate('a,c,d,h-m', '2016/01/01','2016/07/01', c('unique-sources', 'num-sources-ipv6'))
d <-  data.frame(p=ip6 / (ip4+ip6) * 100, dates=days)

png(filename='test.png', bg='white')
ggplot() + geom_ribbon(data = d, aes(x = days, y=p, ymax=p+1, ymin=p-1)) 
"

example <- "
A4 <- metricsByDate('a', '2016/01/01','2016/07/01', c('unique-sources', 'num-sources-ipv4'))
A6 <- metricsByDate('a', '2016/01/01','2016/07/01', c('unique-sources', 'num-sources-ipv6'))

C4 <- metricsByDate('c', '2016/01/01','2016/07/01', c('unique-sources', 'num-sources-ipv4'))
C6 <- metricsByDate('c', '2016/01/01','2016/07/01', c('unique-sources', 'num-sources-ipv6'))

D4 <- metricsByDate('d', '2016/01/01','2016/07/01', c('unique-sources', 'num-sources-ipv4'))
D6 <- metricsByDate('d', '2016/01/01','2016/07/01', c('unique-sources', 'num-sources-ipv6'))

Agg4 <- metricsByDate('a,c,d,h,j-m', '2016/01/01','2016/07/01', c('unique-sources', 'num-sources-ipv4'))
Agg6 <- metricsByDate('a,c,d,h,j-m', '2016/01/01','2016/07/01', c('unique-sources', 'num-sources-ipv6'))

A <- A6 / (A4+A6) * 100
C <- C6 / (C4+C6) * 100
D <- D6 / (D4+D6) * 100
Agg <- Agg6 / (Agg4+Agg6) * 100

lets <- data.frame(dates=days, A=A, C=C, D=D, Agg=Agg)

png(filename='test.png', width=1000, height=800)
"

example <- "
ggplot(lets, aes(A)) + labs(title='Density IPv6 Sources A Root', y='Density', x='%') +
    geom_density()
"


example <- "
pv <- 0.25 ## Width of ribbon
ggplot() + labs(title='% IPv6 Sources', y='%', x='2016', colour = 'Root') +
    geom_ribbon(data = lets, aes(x = dates, y=A, ymax=A+pv, ymin=A-pv, colour='A')) +
        geom_ribbon(data = lets, aes(x = dates, y=C, ymax=C+pv, ymin=C-pv, colour='C')) +
            geom_ribbon(data = lets, aes(x = dates, y=D, ymax=D+pv, ymin=D-pv, colour='D'))
"

## TODO: Investigate quantile library 
##ggplot(lets, aes(dates, A)) + geom_point() + geom_quantile()

example <- "
ggplot() + labs(title='% IPv6 Sources', y='%', x='2016', colour = 'Root') +
    geom_point(data=lets, aes(x=dates, y=A, colour='A')) +   geom_smooth(data=lets, aes(x=dates, y=A), method = 'lm', se = FALSE) +
        geom_point(data=lets, aes(x=dates, y=C, colour='C')) +   geom_smooth(data=lets, aes(x=dates, y=C), method = 'lm', se = FALSE) +
            geom_point(data=lets, aes(x=dates, y=D, colour='D')) +   geom_smooth(data=lets, aes(x=dates, y=D), method = 'lm', se = FALSE) +
                geom_point(data=lets, aes(x=dates, y=Agg, colour='Aggregate')) +   geom_smooth(data=lets, aes(x=dates, y=Agg), method = 'lm', se = FALSE)

"

met <- metricsByDate('a','2016/01/01','2016/06/05', c('traffic-sizes', 'udp-response-sizes'))





