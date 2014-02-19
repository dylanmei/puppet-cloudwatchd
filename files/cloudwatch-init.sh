#!/bin/bash
#
# cloudwatchd
#
# chkconfig: 3 50 50
# description: cloudwatchd init.d
. /etc/rc.d/init.d/functions
 
DESC="cloudwatchd"
NAME="cloudwatchd"
DAEMON="/usr/local/sbin/cloudwatchd"
pidfile=/var/run/cloudwatchd.pid
lockfile=/var/lock/subsys/cloudwatchd
RETVAL=0
STOP_TIMEOUT=${STOP_TIMEOUT-10}

# Read default variables file if it is present
[ -r /etc/default/$NAME ] && . /etc/default/$NAME

# Read sysconfig variables file if it is present
[ -r /etc/sysconfig/$NAME ] && . /etc/sysconfig/$NAME

# Determine if we can use the -p option to daemon, killproc, and status.
# RHEL < 5 can't.
if status | grep -q -- '-p' 2>/dev/null; then
    daemonopts="--pidfile $pidfile"
    pidopts="-p $pidfile"
fi
 
start() {
  echo -n $"Starting $NAME: "
  # See if it's already running. Look *only* at the pid file.
  if [ -f ${pidfile} ]; then
    failure "PID file exists for cloudwatchd"
    RETVAL=1
  else
    # Run as process
    $DAEMON ${JS} ${CLOUDWATCHD_CONFIG} ${CLOUDWATCHD_LOGFILE} &
    RETVAL=$?
    # Store PID
    echo $! > ${pidfile}
 
    # Success
    [ $RETVAL = 0 ] && success "cloudwatchd started"
  fi
 
  echo
  return $RETVAL
}
 
stop() {
  echo -n $"Stopping $NAME: "
  killproc -p ${pidfile}
  RETVAL=$?
  echo
  [ $RETVAL = 0 ] && rm -f ${pidfile}
}
 
# See how we were called.
case "$1" in
  start)
  start
  ;;
  stop)
  stop
  ;;
  status)
  status -p ${pidfile} ${prog}
  RETVAL=$?
  ;;
  restart)
  stop
  start
  ;;
  condrestart)
  if [ -f ${pidfile} ] ; then
    stop
    start
  fi
  ;;
  *)
  echo $"Usage: $prog {start|stop|restart|condrestart|status}"
  exit 1
esac
 
exit $RETVAL
