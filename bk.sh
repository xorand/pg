#!/bin/sh

msg () {
    echo -n $(/bin/date +%d.%m.%y\ %H:%M:%S)" $1 "
}

# reading config file
SP=$(dirname "$0")
if [ "$SP" = "." ]; then
    SP=`pwd`
fi
. $SP/pg.conf

# if 1st argument non-empty, take database to backup from it
if [ ! -z "$1" ]; then
    DBS=$1
fi

for DB in ${DBS}; do
    FNAME=/tmp/$DB-$(/bin/date +%Y%m%d).dump
    msg "dumping database [$DB] ..."
    /usr/bin/time -f%E /usr/bin/pg_dump --user postgres -Fc $DB > $FNAME
    msg "copying database [$DB] ..."
    /usr/bin/time -f%E /usr/bin/scp -q $FNAME $HOST:$RPATH
    /bin/rm -f $FNAME 
    msg "backup [$DB] done"
    printf "\n"
done

if [ -z "$1" ]; then
    msg "cleaning old backups ..."
    /usr/bin/time -f%E /usr/bin/ssh -q $HOST "find $RPATH -type f -mtime +$DAYS -print0 | xargs -0 rm -f"
    msg "all done"
    printf "\n"
fi
