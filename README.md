# chicago-transit

A tool for building a database of transit events by using the CTA bus tracker API.

## Dependencies

### PostgreSQL and PostGIS.

You'll need [PostgreSQL](http://www.postgresql.org) and the [PostGIS](http://www.postgis.org) extension installed. Create a database and load `cta.ddl` to set up the schema.

### SBCL and Quicklisp

You will need [SBCL](http://www.sbcl.org) to run chicago-transit, along with the [Quicklisp](http://quicklisp.org) library manager.

## Configuration

Copy the file `config.lisp.sample` to `config.lisp` and set the \*bus-api-key\* (you can obtain a key at http://www.transitchicago.com/developers/bustracker.aspx) and \*database-connection-spec\* parameters.

## Building

Run `./build.sh` in the top-level directory. The first time you do this, Quicklisp will download and install all of the Lisp dependencies.

## Running

Run the `chicago-transit` binary in the same directory as your `config.lisp`. This will open a REPL where you can interact with the application; as well as a Swank listener on the default port (4005) so that you can connect to it from Slime in Emacs.

Every time you start the application, it will immediately update its local list of CTA routes and stops. It will then update that list every night at midnight, and retrieve predictions for every bus every minute on the minute.

## Logging

All logging is done to the syslog facility using the identifier bus-api. On older systems, you'll want to look in `/var/log/syslog` or `/var/log/messages` or something like that. To watch the logs on a modern system using systemd, run `journalctl -f SYSLOG_IDENTIFIER=bus-api`.

## Controlling the process

`(cta.controller:start)` at the REPL starts the polling loops (but this should not be necessary unless you have manually stopped them). `(cta.controller:stop)` suspends them. `(cta.controller:debugging-on)` and `(cta.controller:debugging-off)` enable and disable a debugging mode where the URL of every HTTP request made to the bus tracker API is logged to syslog.