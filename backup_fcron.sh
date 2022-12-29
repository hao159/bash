#!/bin/sh

DATE_EXEC="$(date "+%Y-%m-%d")"
BK_FILE=/home/bk-cron/fcron-bk-$(date +"%d-%m-%Y")
echo $BK_FILE
FCRON_FILE='/usr/local/var/spool/fcron/root.orig'

cp $FCRON_FILE $BK_FILE
echo "Backup fcron ok"
