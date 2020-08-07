#! /usr/bin/env sh

DAEMON=redshift

pgrep $DAEMON | xargs -n1 kill -9

$DAEMON -x
$DAEMON
