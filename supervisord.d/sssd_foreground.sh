#!/bin/bash

# Command and pidfile for sssd
command="/usr/sbin/sssd"
pidfile="/var/run/sssd/sssd.pid"

# Proxy signals
function kill_app() {
  kill $(cat $pidfile)
  exit 0
}
trap "kill_app" TERM SIGINT SIGTERM SIGQUIT

# Launch daemon
$command
sleep 1

# Loop while the pidfile and the process exist
while [ -f $pidfile ] && kill -0 $(cat $pidfile) ; do
  sleep 1
done

# Uncaught condition
exit -1

