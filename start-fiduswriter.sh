#!/bin/sh -e
#
# Script used to setup and run fiduswriter

if [ -f /data/fiduswriter.sql ]
  then
    if [ -f /fiduswriter/fiduswriter.sql ] ; then
        rm /fiduswriter/fiduswriter.sql
    fi
  else
    echo '*** Moving fiduswriter.sql to /data ...'
    mv /fiduswriter/fiduswriter.sql /data/fiduswriter.sql
fi
ln -sf /data/fiduswriter.sql /fiduswriter/fiduswriter.sql

if [ -f /data/media ]
  then
    if [ -f /fiduswriter/media ] ; then
      rm /fiduswriter/media
    fi
  else
    echo '*** Moving media-folder to /data ...'
    mv /fiduswriter/media /data/media
fi
ln -sf /data/media /fiduswriter/media

if [ -f /data/configuration.py ]
  then
    if [ -f /fiduswriter/configuration.py ] ; then
      rm /fiduswriter/configuration.py
    fi
  else
    echo '*** Moving configuration.py to /data ...'
    mv /fiduswriter/configuration.py /data/configuration.py
fi
ln -sf /data/configuration.py /fiduswriter/configuration.py

chmod -R 777 /data
echo '*** Starting server ...'

su fiduswriter
cd /fiduswriter
python manage.py runserver


exit 0
