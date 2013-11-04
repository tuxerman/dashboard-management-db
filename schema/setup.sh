#!/bin/sh


if [ "$1" != "" ]
then
DB="--dbname $1"
fi

#PVER=`psql --version | head -1 | awk '{print $3;}' | cut -f1-2 -d.`
PVER=8.4
CONTRIBDIR=/usr/share/postgresql/$PVER/contrib

# fixme, you need perms to create databases
# You need:
# pgplang
# pgcrypto
# createdb $DB
# pg_buffercache.sql
# postgis (for geoip)
psql $DB -f init.sql
createlang plpgsql $DB
psql $DB -f $CONTRIBDIR/pgcrypto.sql
psql $DB -f $CONTRIBDIR/pg_buffercache.sql

# FIXME Use bytea for ids as sha1 hashes to make the db replicatable
# FIXME Why use ids at all? DJANGO requires them until after GSOC 2011

# createdb perms
# FIXME set defaults right in defaults.sql and enforce
# FIXME: thoroughly review indexes.sql  before using it
# (it also helps to have no indexes during imports)
# Similarly permissions and triggers

FILES="types.sql functions.sql mgmt.sql table_templates.sql gen_capetown.sh *.gsql mgmt_data.sql" 
for i in $FILES
do
psql -f $i $DB
done

