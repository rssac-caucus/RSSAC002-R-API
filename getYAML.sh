#!/usr/local/bin/ksh
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

# This script downloads and normalizes directory structure for RSSAC002 YAML data for all root DNS operators
# This script is intended to be run wtihout any arguments

LOGFILE=getYAML.log
WGET=/usr/local/bin/wget

# Usage dlaod URI directory options
# URI MUST end with a '/'
function dload {
    if [ ! -d $2 ];
    then
       mkdir $2
    fi

    DIRS="$(expr $(echo $1 | tr -dc '/' | wc -c) - 3)"

    echo "Downloading $1 TO $2"
    echo "Downloading $1 TO $2" >>$LOGFILE
    $WGET -m -nv -nH -P $2 --cut-dirs $DIRS -A "$2*.yaml" $1 $3 2>&1 |grep .yaml >>$LOGFILE
}

: > $LOGFILE

dload http://a.root-servers.org/rssac-metrics/raw/ a-root
dload https://b.root-servers.org/rssac/ b-root --no-check-certificate
dload http://c.root-servers.org/rssac002-metrics/ c-root
dload http://droot-web.maxgigapop.net/rssac002/ d-root
dload https://e.root-servers.org/rssac/ e-root --inet4-only
dload http://h.root-servers.org/rssac002-metrics/ h-root
dload http://j.root-servers.org/rssac-metrics/raw/ j-root
dload https://www-static.ripe.net/dynamic/rssac002-metrics/ k-root
dload http://stats.dns.icann.org/rssac/ l-root
dload https://rssac.wide.ad.jp/rssac002-metrics/ m-root

echo $(grep .yaml $LOGFILE |wc -l) YAML files downloaded
find . -type f|grep yaml|awk -F / '{print "Have YAML from " $2}'|sort|uniq
find . -type f -mtime 1|grep yaml|awk -F / '{print "Recent YAML from " $2}'|sort|uniq


