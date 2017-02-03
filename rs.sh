#!/bin/sh

msg () {
    echo -n $(/bin/date +%d.%m.%y\ %H:%M:%S)" $1 "
}

# reading config file
SP=$(dirname "$SCRIPT")
if [ "$SP" = "." ]; then
    SP=`pwd`
fi
. $SP/pg.conf

# 1st argument dbname 2nd argument backup filename
DB=$1
FNAME=$2

msg "preparing destination [$DB] ..."
/usr/bin/dropdb --user postgres $DB >/dev/null 2>&1
/usr/bin/createdb --user postgres $DB >/dev/null 2>&1
if [ $? != 0 ]; then
    printf "FAIL\n"
    exit
fi
printf "OK\n"
msg "copying dump [$FNAME] to tmp dir ..."
/usr/bin/time -f%E /usr/bin/scp -q $HOST:$PATH$FNAME /tmp
msg "restore [$DB] from dump ..."
/usr/bin/time -f%E /usr/bin/pg_restore --user postgres -d $DB /tmp/$FNAME 
/bin/rm -f /tmp/$FNAME
msg "restore [$FNAME] -> [$DB] done"
printf "\n"
