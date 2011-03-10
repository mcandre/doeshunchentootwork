#!/bin/sh
#
# Install:
#
# chmod a+x hunchentoot.sh
# sudo cp hunchentoot.sh /etc/init.d/hunchentoot
# sudo update-rc.d hunchentoot defaults
#
# Uninstall:
#
# sudo rm /etc/rc*/hunchentoot
# sudo rm /etc/init.d/hunchentoot

HUNCHENTOOT_DIR=/srv/d_hactar/usr/src/doeshunchentootwork

case "$1" in
  start)
    echo "Starting Hunchentoot..."
    $HUNCHENTOOT_DIR/doeshunchentootwork > /dev/null 2>&1 &
    ;;
  stop)
    echo "Stopping Hunchentoot..."
    killall doeshunchentootwork
    ;;
  restart)
    echo "Restarting Hunchentoot..."
    killall doeshunchentootwork
    $HUNCHENTOOT_DIR/doeshunchentootwork > /dev/null 2>&1 &
    ;;
  *)
    echo "Usage: $0 start|stop|restart"
    exit 1
    ;;
esac

exit 0
