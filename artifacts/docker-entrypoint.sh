#!/bin/sh
set -e

for SCRIPTFILE in /docker-entrypoint-scripts/generate-nginx-conf-includes/*
do
    if [ -f $SCRIPTFILE -a -x $SCRIPTFILE ]
    then
        $SCRIPTFILE
    fi
done

for SCRIPTFILE in /docker-entrypoint-scripts/generate-nginx-lua-modules/*
do
    if [ -f $SCRIPTFILE -a -x $SCRIPTFILE ]
    then
        $SCRIPTFILE
    fi
done

for SCRIPTFILE in /docker-entrypoint-scripts/generate-misc/*
do
    if [ -f $SCRIPTFILE -a -x $SCRIPTFILE ]
    then
        $SCRIPTFILE
    fi
done

exec "$@"
