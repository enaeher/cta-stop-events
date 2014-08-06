# chicago-transit

A tool for building a database of transit events by using the CTA bus tracker API.

## Setup

### Database

You'll need [PostgreSQL](http://www.postgresql.org) and the [PostGIS](http://www.postgis.org) extension installed. Create a database and load `cta.ddl` to set up the schema. Configure the \*database-connection-spec\* in `controller/variables.lisp` to match your database information.

### API key

Configure the \*bus-api-key\* in `api/variables.lisp`.

### SBCL

You will need [SBCL](http://www.sbcl.org) to run chicago-transit (it may run on other Common Lisps but is totally untested). Eventually I hope to package some shell scripts to facilitate running it, but at the moment you'll need to start it from the REPL. At the SBCL REPL, run:

```commonlisp
* (asdf:initialize-source-registry (:tree "/path/to/chicago-transit"))
* (require 'cta)
```

## Logging

All logging is done to the syslog facility using the identifier bus-api. On older systems, you'll want to look in `/var/log/syslog` or `/var/log/messages` or something like that. To watch the logs on a modern system using systemd, run `journalctl -f SYSLOG_IDENTIFIER=bus-api`.

## Controlling the process

`(cta.controller:start)` at the REPL initiates the polling loops. `(cta.controller:stop)` suspends them. `(cta.controller:debugging-on)` and `(cta.controller:debugging-off)` enable and disable a debugging mode where the URL (including all parameters) of every HTTP request made to the bus tracker API is logged to syslog.