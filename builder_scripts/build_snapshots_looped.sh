#!/bin/sh
#
# pfSense snapshot building system
# (C)2007, 2008, 2009 Scott Ullrich
# All rights reserved
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#

echo

PWD=`pwd`

if [ ! -f "$PWD/pfsense-build.conf" ]; then
	echo "You must run this utility from the same location as pfsense-build.conf !!"
	exit 1
fi

rm -f /tmp/pfSense_do_not_build_pfPorts

# Handle command line arguments
while test "$1" != "" ; do
	case $1 in
		--noports|-n)
		echo "$2"
		NO_PORTS=yo
		shift
	;;
	esac
	shift
done

# Main builder loop
COUNTER=0
while [ /bin/true ]; do
	COUNTER=`expr $COUNTER + 1`
	echo ">>> Starting builder run #${COUNTER}..."
	# We can disable ports builds
	if [ "$NO_PORTS" = "yo" ]; then
		echo ">>> Not building pfPorts at all during this snapshot builder looped run..."
		touch /tmp/pfSense_do_not_build_pfPorts
	else
		if [ "$COUNTER" -gt 1 ]; then 
			echo ">>> Previous snapshot runs deteceted, not building pfPorts again..."
			touch /tmp/pfSense_do_not_build_pfPorts
		else
			echo ">>> Building pfPorts on this snapshot run..."
			rm -f /tmp/pfSense_do_not_build_pfPorts
		fi
	fi
	sh ./build_snapshots.sh
	# Grab a random value and sleep
	value=`od -A n -d -N2 /dev/random | awk '{ print $1 }'`
	# Sleep for that time.
	echo ">>> Sleeping for $value in between snapshot builder runs"
	# Count some sheep.
	sleep $value
done
