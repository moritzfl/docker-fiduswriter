#!/bin/sh -e
#
# Script to run fiduswriter and/or perform the initial setup 

echo "*** Running as user $(whoami) ..."

if [ -f /data/configuration.py ]; then
    echo '*** Fiduswriter will use the settings found in /data/configuration.py ...'
else
    echo '*** /data/configuration.py was not found. A new file with default settings will now be created ...'
    fiduswriter startproject
fi

# If setup-performed.info does not yet exist, we assume that this is a "fresh" container and perform the setup.
# This should also take care of any transpiling that may be required between versions.
# This is however not an ideal solution as it makes the container stateful meaning that it may perform
# different operations even if the same input data is used (i.e. the files from the /data directory are the same)
if ! [ -f /fiduswriter/setup-performed.info ]; then
    echo '*** Executing fiduswriter setup as this is the first time that this container is launched ...'
	fiduswriter setup
	touch /fiduswriter/setup-performed.info
fi

# If the fiduswriter/media directory exists, this means that a symlink can not directly
# be created. Instead we need to do the following before creating the symlink:
# - remove the fiduswriter/media directory, if the user already has data/fiduswriter
# - copy move the folder from fiduswriter/media to data/fiduswriter
if [ -d /fiduswriter/media ] ; then
  if ! [ -L /fiduswriter/media ] ; then
	if [ -d /data/media ] ; then
		rm -rf /fiduswriter/media
	else
	    mv /fiduswriter/media /data/media
	fi
  fi
fi
if ! [ -L /fiduswriter/media ] ; then
  ln -sf /data/media /fiduswriter
fi

if [ -f /fiduswriter/configuration.py ] ; then
  if ! [ -L /fiduswriter/configuration.py ] ; then
	if [ -f /data/configuration.py ] ; then
		rm /fiduswriter/configuration.py
	else
	    mv /fiduswriter/configuration.py /data/configuration.py
	fi
  fi
fi
if ! [ -L /fiduswriter/configuration.py ] ; then
  ln -sf /data/configuration.py /fiduswriter/configuration.py
fi

if [ -f /fiduswriter/fiduswriter.sql ] ; then
  if ! [ -L /fiduswriter/fiduswriter.sql ] ; then
	if [ -f /data/fiduswriter.sql ] ; then
		rm /fiduswriter/fiduswriter.sql
	else
	    mv /fiduswriter/fiduswriter.sql /data/fiduswriter.sql
	fi
  fi
fi
if ! [ -L /fiduswriter/fiduswriter.sql ] ; then
  ln -sf /data/fiduswriter.sql /fiduswriter/fiduswriter.sql
fi

# Run the fiduswriter-server
echo '*** Executing fiduswriter ...'
fiduswriter runserver

exit 0
