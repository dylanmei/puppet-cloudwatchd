#!/bin/bash

if [ "$#" -lt 2 ]; then
  echo "Usage: $(basename $0) /path/to/cloudwatch.js /path/to/configfile path/to/logfile" >&2
  exit 1
fi

JS=$1
CONFIGFILE=$2
LOGFILE=$3


NODE=$(which node || which nodejs)

if ! [ -x "$NODE" ]; then
  echo "Unable to run - node '${NODE}' cannot be executed" >&2
  exit 255
fi

if ! [ -r "$JS" ]; then
  echo "Unable to read '$JS' - file is either missing or unreadable"
  exit 255
fi

if ! [ -r "$CONFIGFILE" ]; then
  echo "Unable to read '$CONFIGFILE' - file is either missing or unreadable"
  exit 255
fi

exec 3>&2
if [ -n "$LOGFILE" ]; then
  exec 1>>$LOGFILE
  exec 2>>$LOGFILE
fi

echo "Running $NODE $JS $CONFIGFILE"
exec $NODE $JS $CONFIGFILE

echo "Unable to execute ${NODE} ${JS} ${CONFIGFILE}!" >&3
exit 1
