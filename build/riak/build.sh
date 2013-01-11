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

PROG=riak
VER=1.2.1
VERHUMAN=$VER
PKG=omniti/database/riak
SUMMARY="Riak highly scalable, fault-tolerant distributed database"
DESC="$SUMMARY"

BUILD_DEPENDS_IPS="omniti/runtime/erlang"
DEPENDS_IPS="developer/dtrace library/security/openssl
    shell/bash system/library/g++-4-runtime system/library/gcc-4-runtime
    system/library system/library/math"
PREFIX=/opt/riak

PATH=$SRCDIR/bin:/opt/omni/bin:$PATH
export PATH

build() {
  pushd $TMPDIR/$BUILDDIR > /dev/null || logerr "cannot change to $BUILDDIR"
  logcmd gsed -i -e 's:OpenSolaris:OmniOS:g' $TMPDIR/$BUILDDIR/package/Makefile
  logcmd $MAKE clean
  CC=gcc CXX=g++ CFLAGS="-m64" logcmd $MAKE -C package buildrel REPO=riak REPO_TAG=riak-$VER PKG_VERSION=$VER
  logcmd mkdir -p $DESTDIR/$PREFIX
  logcmd cp -r -p rel/riak/* $DESTDIR/$PREFIX/
  popd > /dev/null
}

init
download_source $PROG $PROG $VER
patch_source
cp files/vars.config $TMPDIR/$BUILDDIR/rel/vars.config || \
  logerr "vars.config failed"
prep_build
build
logcmd mkdir -p $DESTDIR/lib/svc/manifest/application
logcmd cp files/*.xml $DESTDIR/lib/svc/manifest/application/ || \
  logerr "cannot install SMF manifests"
logcmd chmod 444 $DESTDIR/lib/svc/manifest/application/*.xml || \
  logerr "cannot install SMF manifests"
logcmd cp files/riak-epmd $DESTDIR/opt/riak/bin/riak-epmd || \
  logerr "cannot install riak-epmd start script"
logcmd chmod 555 $DESTDIR/opt/riak/bin/riak-epmd || \
  logerr "cannot chmod riak-epmd start script"
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
