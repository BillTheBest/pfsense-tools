#!/bin/sh

TOOLSDIR=/home/pfsense/tools/builder_scripts/
OVERLAY_PATH="$TOOLSDIR/builder_profiles/freebsd_only7"

cp $OVERLAY_PATH/pfsense_local.sh    $TOOLSDIR
cp $OVERLAY_PATH/pfsense-build.conf  $TOOLSDIR

mkdir -p $SRCDIR

cd $TOOLSDIR
./clean_build.sh
./apply_kernel_patches.sh
