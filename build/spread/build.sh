#!/usr/bin/bash
#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License, Version 1.0 only
# (the "License").  You may not use this file except in compliance
# with the License.
#
# You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
# or http://www.opensolaris.org/os/licensing.
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each
# file and include the License file at usr/src/OPENSOLARIS.LICENSE.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END
#
#
# Copyright 2011-2012 OmniTI Computer Consulting, Inc.  All rights reserved.
# Use is subject to license terms.
#
# Load support functions
. ../../lib/functions.sh

PROG=spread
VER=3.17.3
VERHUMAN=$VER
PKG=omniti/network/spread
SUMMARY="Spread group communication system"
DESC="$SUMMARY"

SRCNAME=$PROG-src
BUILDDIR=$SRCNAME-$VER

# XXX dual architecture support doesn't work with 64bit daemons, so we 
# remove the 64bit one before generating the package.
rm_64bit_daemon_hack() {
  logcmd rm ${DESTDIR}/opt/omni/sbin/amd64/spread
}

copy_manifest() {
    # SMF manifest
    logmsg "--- Copying SMF manifest"
    logcmd mkdir -p ${DESTDIR}/lib/svc/manifest/network
    logcmd cp $SRCDIR/files/spread.xml ${DESTDIR}/lib/svc/manifest/network
}

init
download_source $PROG $SRCNAME $VER
patch_source
prep_build
build
rm_64bit_daemon_hack
make_isa_stub
copy_manifest
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
