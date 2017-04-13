#!/bin/sh -e
#
# Script used to setup and run fiduswriter

# Handle fiduswriter.sql
if [ -f /data/fiduswriter.sql ]
  # if fiduswriter.sql exists in the data directory remove the default version originally
  # in place in the fiduswriter-directory. Later a symlink will be created in its place in
  # the fiduswriter-directory.
  then
    if [ -f /fiduswriter/fiduswriter.sql ] ; then
      rm /fiduswriter/fiduswriter.sql
    fi
  else
    # if fiduswriter.sql did not exist in the /data directory check if the default file
    # still exists in the fiduswriter directory.
    # If it does not exist, print a message for the user informing him that the default
    # version could not be copied and stop the execution. 
    # Otherwise copy the default file to /data.
    if [ -L /fiduswriter/fiduswriter.sql ]; then
      echo '*** Symlink for configuration.py already in place. Can not copy default version to /data folder ...'
      exit 1
    else
      echo '*** Moving fiduswriter.sql to /data ...'
      mv /fiduswriter/fiduswriter.sql /data/fiduswriter.sql
    fi
fi
# Create symlink /fiduswriter/fiduswriter.sql->/data/fiduswriter.sql 
ln -sf /data/fiduswriter.sql /fiduswriter/fiduswriter.sql


# Handle media directory - analog to fiduswriter.sql
if [ -d /data/media/ ]
  then
    if [ -e /fiduswriter/media ] ; then
      rm -rf /fiduswriter/media
    fi
  else
    if [ "$(readlink -- "/fiduswriter/media")" = /data/media ]; then
      echo '*** Symlink for media-folder already in place. Can not copy copy default version to /data folder ...'
      exit 1
    else
      echo '*** Moving media-folder to /data ...'
      mv /fiduswriter/media /data/media
    fi
fi
ln -sf /data/media /fiduswriter


# Handle configuration.py - analog to fiduswriter.sql
if [ -f /data/configuration.py ]
  then
    if [ -f /fiduswriter/configuration.py ] ; then
      rm /fiduswriter/configuration.py
    fi
  else
    if [ -L /data/configuration.py ]; then
      echo '*** Symlink for configuration.py already in place. Can not copy default version to /data folder ...'
      exit 1
    else
      echo '*** Moving configuration.py to /data ...'
      mv /fiduswriter/configuration.py /data/configuration.py
    fi
fi
ln -sf /data/configuration.py /fiduswriter/configuration.py



echo '*** Starting server ...'
cd /fiduswriter
python manage.py runserver

exit 0
