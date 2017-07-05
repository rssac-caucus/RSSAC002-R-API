# RSSAC002 Graphing API

This API provides an R interface to RSSAC002 metrics colllected by the
DNS root servers.

[RSSAC002v3](https://www.icann.org/en/system/files/files/rssac-002-measurements-root-06jun16-en.pdf)

## Root Server Data
rssac002.R expects that data from
[RSSAC002-DATA](https://github.com/rssac-caucus/RSSAC002-data) is 
available in ./RSSAC002-data. From ./ type `git clone
https://github.com/rssac-caucus/RSSAC002-data` to retrieve this data,
and `git pull https://github.com/rssac-caucus/RSSAC002-data` to update it.

## rssac002.R
The main file containing the following functions written in R.

### metricsByDate()
**metricsByDate(path, letters, startDate, endDate, metrics)**
Return a vector of values ordered by date.

**path** is the relative or absolute location of the rssac002 data
  files as downloaded by **getYaml.sh**.

**letters** can be a single letter(a), a range(a-c), a list(a,b,g), or a combination of all 3.
**letters** is case inspecific.
If **letters** is not a single letter an aggregate will be returned.

**startDate** and **endDate** take the form YYYY-MM-DD, **endDate** will not be included
*Example: 2016-02-26*

**metrics** is a vector of requested metrics as strings arranged in a
hierarchy to identify a single vector of values. The length of **metrics** can be either 2 or 3.
The first and second entry of metrics are required. The third entry of metrics is optional dependent upon the metric being queried.
*Examples: c("traffic-sizes", "udp-request-sizes", "16-31"), c("unique-sources", "num-sources-ipv6"), c("rcode-volume", "10")*

#### Special-case traffic-sizes
If **metricsByDate(path, letters, startDate, endDate, c('traffic-sizes', $SIZE-TYPE))**
Where $SIZE-TYPE == 'udp-request-sizes' || 'udp-response-sizes' || 'tcp-request-sizes' || 'tcp-response-sizes'.
**metricsByDate()** will return a 2 dimensional list of all sizes of $SIZE-TYPE by date.
NOTE: In this special-case instantiation **metricsByDate()** will
return a list and not a vector.

### maxN()
**maxN(ll, N)**
Return N most maximum values from a list preserving names and order.

**ll** is a list of numeric values

**N** is number of elements to return

### perc()
**perc(ll, r=2)**
Compute percentage of sum(**ll**) for each value in a list preserving names and order.

**ll** is a list of numeric values

**r** is passed to round() as digits=**r**

## /examples directory
A directory full of examples of increasing complexity.

## FAQ
Q: What does this mean?
`
Warning in loop_apply(n, do.ply) :
  Removed 2 rows containing missing values (stat_smooth).
`
A: We store all values as doubles with the exception of zero. Zero is
stored as an integer. What this error likely means is that we
interpreted a value in a YAML file that was larger than could be
stored in a double. Often this happens in times of DDOS when
the unique-sources metric grows exceptionally large. It's an outlyer
and unfortunately the R language doesn't have an easy way to define
a new type that can hold these large values. My advice is simply to
ignore them.
