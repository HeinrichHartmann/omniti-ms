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

PROG=emacs
VER=24.5
VERHUMAN=$VER
PKG=omniti/editor/emacs
SUMMARY="GNU Emacs is an extensible, customizable text editor-- and more."
DESC="$SUMMARY"

BUILDARCH=64
LDFLAGS64="$LDFLAGS64 -L/usr/gnu/lib/$ISAPART64 -R/usr/gnu/lib/$ISAPART64"

BUILD_DEPENDS_IPS="library/ncurses system/library/gcc-4-runtime"
DEPENDS_IPS="library/ncurses system/library/gcc-4-runtime"

CONFIGURE_OPTS="--with-gif=no --without-x --without-makeinfo"

REPOS=git://git.savannah.gnu.org/emacs
GIT=/usr/bin/git
TAG=emacs-24.5

download_git() {
    pushd $TMPDIR > /dev/null
    logmsg "Checking for source directory"
    if [ ! -d $BUILDDIR ]; then
	logmsg "Checking code out from git repo"
	logcmd $GIT clone $REPOS.git $BUILDDIR || \
            logerr "--- failed to clone source"
	cd $BUILDDIR
    else
	logmsg "Wiping existing git repo"
	cd $BUILDDIR
	git clean -f
    fi
    if [ -n "$TAG" ]; then
        git checkout $TAG
    fi
    popd > /dev/null
}

init
download_git
patch_source
prep_build
run_autogen
build
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
