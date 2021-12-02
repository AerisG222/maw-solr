# maw-solr

![CI](https://github.com/AerisG222/maw-solr/workflows/CI/badge.svg)

This repository previously provided a custom solr container which would include the Postgres JDBC driver for use by dataimporthandler.
However, given that dataimporthandler is deprecated, a standalone application was built (see maw-solr-indexer repo) to acheive the same result.
As such, we can now leverage the official solr image directly rather than using this custom helper.

While this repository no longer defines / creates a custom container, it seems like a useful location to store configuration for the solr instance.
This will allow for easily setting up the container in dev scenarios, as well as provide a place to (potentially) hold other helpful scripts / resources /documents.

It is also worth noting that one option considered was to build a custom container with all the config built in.  While that is convenient to quickly
get started, it does have the requirement of a custom container which must be kept up to date.  It also increases concerns if changes were made in the running instance that might not make their way back into source control.  As such, the config files in the container volume will continue to serve as the golden copy, but the files in this repo will be updated as changes are made so devs can easily update their config, as well as having this serve as a poor man's backup.
