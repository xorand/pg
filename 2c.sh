#!/bin/sh

msg () {
    echo -n $(date +%d.%m.%y\ %H:%M:%S)" $1 "
}

DB1=$1
DB2=$2
msg "dumping database [$DB1] ..."
FNAME=/tmp/$DB1-$(date +%Y%m%d).dump
/usr/bin/time -f%E pg_dump --user postgres -Fc $DB1 > $FNAME
dropdb --user postgres $DB2
createdb --user postgres $DB2
msg "restore database [$DB2] ..."
/usr/bin/time -f%E pg_restore --user postgres -d $DB2 $FNAME 
rm -f $FNAME
msg "[$DB1] -> [$DB2] done"
echo
