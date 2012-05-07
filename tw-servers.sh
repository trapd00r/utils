#!/bin/bash

. /etc/rc.conf
. /etc/rc.d/functions

NAME="teeworlds-tw"
USER="teeworlds"
GROUP="game"
HOMEDIR="/home/teeworlds"
BINFILE="/bin/sh"

check_root()
{
  if [ $(id -u) -ne 0 ]; then
    echo "This script must be run as root"
    stat_fail
    exit 1
  fi
}

start()
{
  if [ $# -gt 0 ]; then
    for _ARGS in $*; do
      if [ ! -f $HOMEDIR/script/$_ARGS ]; then
        echo "Server label does not exist '$HOMEDIR/script/$_ARGS'"
        stat_fail
        exit 1
      fi

      . $HOMEDIR/script/$_ARGS
      /usr/bin/start-stop-daemon --start --background --oknodo --quiet --chuid $USER:$GROUP --name ddrace1 --pidfile $HOMEDIR/run/$_ARGS --make-pidfile --startas $BINFILE -- -c "$PARAMS"

      add_daemon "$_ARGS"
    done
  else
    for _FILES in $HOMEDIR/script/*; do
      . ~/script/$_FILES
      /usr/bin/start-stop-daemon --start --background --oknodo --quiet --chuid $USER:$GROUP --name ddrace1 --pidfile $HOMEDIR/run/$_FILES --make-pidfile --startas $BINFILE -- -c "$PARAMS"

      add_daemon "$_FILES"
    done
  fi

  stat_done
}

stop()
{
  if [ $# -gt 0 ]; then
    for _ARGS in $*; do
      if [ ! -f $HOMEDIR/run/$_ARGS ]; then
        echo "Server label does not exist '$HOMEDIR/script/$_ARGS'"
        stat_fail
        exit 1
      fi

      _PID=$(/bin/cat $HOMEDIR/run/$_ARGS)
      _CPID=$(/bin/ps -o pid --no-headers --ppid $_PID)
      /usr/bin/start-stop-daemon --stop --oknodo --chuid $USER:$GROUP --pidfile $HOMEDIR/run/$_ARGS --retry=TERM/2/KILL/1
      kill -TERM $_CPID
      /bin/rm $HOMEDIR/run/$_ARGS

      rm_daemon "$_ARGS"
    done
  else
    for _FILES in $HOMEDIR/run/*; do
      _PID=$(/bin/cat $HOMEDIR/run/$_FILES)
      _CPID=$(/bin/ps -o pid --no-headers --ppid $_PID)
      /usr/bin/start-stop-daemon --stop --oknodo --chuid $USER:$GROUP --pidfile $HOMEDIR/run/$_FILES --retry=TERM/2/KILL/1
      kill -TERM $(/bin/ps -o pid --no-headers --ppid $_CPID)
      /bin/rm $HOMEDIR/run/$_FILES

      rm_daemon "$_FILES"
    done
  fi

  stat_done
}

_OPTION=$1
shift 1

case "$_OPTION" in
  start)
    stat_busy "Starting $NAME"

    check_root
    start $*
  ;;

  stop)
    stat_busy "Stopping $NAME"

    check_root
    stop $*
  ;;

  restart)
    stat_busy "Restarting $NAME"

    check_root
    if [ !-z $($BINFILE -ls | /bin/grep "$NAME") ]; then
      $0 stop $*
      sleep 5
    fi

    $0 start $*
  ;;

  *)
    echo "Usage: $0 {start|stop|restart}"
  ;;
esac

exit 0
