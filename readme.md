# scripts for automate postgresql backup/restore operations

# bk.sh
backup script, takes settings from pg.conf

$1 override databases to backup from config file

# 2ch.sh
copy $1 database to $2 database

$2 database recreated during process - be careful

# rs.sh
restore to $1 database $2 dump from remote location

takes settings from pg.conf

$1 database recreated during process - be careful
