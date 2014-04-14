#!/bin/sh
#
### BEGIN INIT INFO
# Provides:          iiod
# Required-Start:    $local_fs $remote_fs
# Required-Stop:     $local_fs $remote_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: IIO Server Daemon
### END INIT INFO

. /lib/lsb/init-functions

# Server-side demuxing by default
IIOD_OPTS=-D

if test -f /etc/default/iiod; then
    . /etc/default/iiod
fi

case "$1" in
	start)
		log_daemon_msg "Starting IIO Server Daemon" "iiod" || true
		if start-stop-daemon -S -b -q -m -p /var/run/iiod.pid -x /usr/sbin/iiod -- $IIOD_OPTS; then
			log_end_msg 0 || true
		else
			log_end_msg 1 || true
		fi
		;;

	stop)
		log_daemon_msg "Stopping IIO Server Daemon" "iiod" || true
		if start-stop-daemon -K -q -p /var/run/iiod.pid; then
			log_end_msg 0 || true
		else
			log_end_msg 1 || true
		fi
		;;

	status)
		if [ -f /var/run/iiod.pid ] ; then
			status_of_proc -p /var/run/iiod.pid /usr/sbin/iiod iiod && exit 0 || exit $?
		else
			status_of_proc /usr/sbin/iiod iiod && exit 0 || exit $?
		fi
		;;

	*)
		log_action_msg "Usage: /etc/init.d/iiod.sh {start|stop|status}" || true
		exit 1
esac

exit 0
