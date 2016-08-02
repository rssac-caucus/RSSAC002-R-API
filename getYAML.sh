#!/usr/local/bin/ksh
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
    $WGET -m -nv -nH -P $2 --cut-dirs $DIRS -A "$2*.yaml" $1 $3 2>&1 |grep .yaml >>$LOGFILE
}

: > $LOGFILE

dload http://a.root-servers.org/rssac-metrics/raw/ a-root
dload https://b.root-servers.org/rssac/ b-root --no-check-certificate
dload http://c.root-servers.org/rssac002-metrics/ c-root
dload http://droot-web.maxgigapop.net/rssac002/ d-root
dload http://h.root-servers.org/rssac002-metrics/ h-root
dload http://j.root-servers.org/rssac-metrics/raw/ j-root
dload https://www-static.ripe.net/dynamic/rssac002-metrics/ k-root
dload http://stats.dns.icann.org/rssac/ l-root
dload https://rssac.wide.ad.jp/rssac002-metrics/ m-root

echo $(grep .yaml $LOGFILE |wc -l) YAML files downloaded
find . -type f|grep yaml|awk -F / '{print "Have YAML from " $2}'|sort|uniq
find . -type f -mtime 1|grep yaml|awk -F / '{print "Recent YAML from " $2}'|sort|uniq


