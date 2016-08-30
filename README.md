# RSSAC002 Graphing API

This API provides an R interface to RSSAC002 metrics colllected by the
DNS root servers.

[RSSAC002v3](https://www.icann.org/en/system/files/files/rssac-002-measurements-root-06jun16-en.pdf)

## getYAML.sh

A UNIX shell script to download the RSSAC002 YAML files. Put
this in a cron job somewhere to run periodically.

## rssac002.R
The main file containing the following functions written in R.

### metricsBydate()

**metricsByDate(path, letters, startDate, endDate, metrics)**
**metricsByDate()** Returns a vector of values ordered by date.

**path** is the relative or absolute location of the rssac002 data
  files as downloaded by **getYaml.sh**.

**letters** can be a single letter(a), a range(a-c), a list(a,b,g), or a combination of all 3.
**letters** is case inspecific.
If **letters** is not a single letter an aggregate will be returned.

**startDate** and **endDate** take the form YYYY-MM-DD, **endDate** will not be included
*Example: 2016-02-30*

**metrics** is a vector of requested metrics as strings arranged in a
hierarchy to identify a single vector of values. The length of **metrics** can be either 2 or 3.
The first and second entry of metrics are required. The third entry of metrics is optional dependent upon the metric being queried.
*Examples: c("traffic-sizes", "udp-request-sizes", "16-31"), c("unique-sources", "num-sources-ipv6"), c("rcode-volume", "10")*

#### Special-case traffic-sizes
If **metricsBydate(path, letters, startDate, endDate, c('traffic-sizes', $SIZE-TYPE))**
Where $SIZE-TYPE == 'udp-request-sizes' || 'udp-response-sizes' || 'tcp-request-sizes' || 'tcp-response-sizes'.
**metricsByDate()** will return a 2 dimensional list of all sizes of $SIZE-TYPE by date.
NOTE: In this special-case instantiation **metricsByDate()** will
return a list and not a vector.

### maxN()
**maxN(ll, N)**
Return N most maximum values from a list preserving names and order
**ll** is a list of numeric values
**N** is number of elements to return

### perc()
**perc(ll, r=2)**
Compute percentage of sum(**ll**) for each value in a list preserving names and order
**ll** is a list of numeric values
**r** is passed to round() as digits=**r**

## /examples directory
A directory full of examples of increasing complexity.



