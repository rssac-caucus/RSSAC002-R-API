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

source("rssac002.R") ## Include our RSSAC002 API

##met <- metricsByDate('a',"2016/01/01","2016/01/20", c("unique-sources", "num-sources-ipv6"))
##met <- metricsByDate('a',"2016/01/01","2016/01/26", c("traffic-sizes", "udp-response-sizes", "192-207"))
##met <- metricsByDate('a-b',"2016/01/01","2016/01/20", c("traffic-volume", "dns-tcp-queries-received-ipv4"))
##met <- metricsByDate('a,j',"2016/01/01","2016/01/20", c("rcode-volume", "0"))
##met <- metricsByDate('a',"2016/01/01","2016/01/20", c("load-time", "2016011000"))

ip6_sources <- metricsByDate('a',"2016/01/01","2016/07/01", c("unique-sources", "num-sources-ipv6-aggregate"))
dates <- seq(as.Date("2016/01/01", "%Y/%m/%d"), len=182, by="1 day")
png(filename="ip6_sources_aggregate_A.png", bg="white")
qplot(x=dates, y=ip6_sources)

