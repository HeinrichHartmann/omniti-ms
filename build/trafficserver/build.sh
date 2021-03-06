#!/usr/bin/bash

# Load support functions
. ../../lib/functions.sh

PROG=trafficserver
VER=6.2.0
PKG=omniti/server/trafficserver
SUMMARY="Apache Traffic Server - HTTP cache"
DESC="$SUMMARY"

PREFIX="/opt/ts"
reset_configure_opts

[[ $BUILDARCH == 'both' ]] && BUILDARCH=64

BUILD_DEPENDS_IPS="library/expat library/security/openssl library/pcre database/sqlite-3 library/zlib library/readline compress/xz omniti/runtime/tcl-8"
DEPENDS_IPS="$BUILD_DEPENDS_IPS system/library/gcc-4-runtime system/library/g++-4-runtime"

LDFLAGS64="-L/opt/omni/lib/$ISAPART64 -R/opt/omni/lib/$ISAPART64 \
           -R$PREFIX/lib"

CPPFLAGS="-I/opt/omni/include -I/usr/include/pcre"
CPPFLAGS64="-D__WORDSIZE=64 -I/opt/omni/include/amd64"

CONFIGURE_OPTS="
    --with-tcl=/opt/omni/lib/$ISAPART64
    --enable-experimental-plugins
    --enable-wccp
    --enable-test-tools
"

# Custom configure_opts_64 because we don't want amd64 suffixes (single arch
# build)
CONFIGURE_OPTS_64="--prefix=$PREFIX
        --sysconfdir=$PREFIX/etc
        --includedir=$PREFIX/include
        --bindir=$PREFIX/bin
        --sbindir=$PREFIX/sbin
        --libdir=$PREFIX/lib
        --libexecdir=$PREFIX/libexec
	--mandir=$PREFIX/share/man
        --enable-experimental-plugins"

install_manifest() {
    logmsg "Placing SMF manifest"
    logcmd mkdir -p $DESTDIR/var/svc/manifest/network/http || \
        logerr "--- failed to create manifest directory"
    logcmd cp $SRCDIR/files/trafficserver.xml $DESTDIR/var/svc/manifest/network/http || \
        logerr "--- failed to install manifest"
}

install_method() {
    logmsg "Placing SMF method script"
    logcmd mkdir -p $DESTDIR/lib/svc/method || \
        logerr "--- failed to create manifest directory"
    logcmd cp $SRCDIR/files/trafficserver.method $DESTDIR/lib/svc/method/trafficserver || \
        logerr "--- failed to install method script"
}

install_config() {
    logmsg "Placing default config files"
    logcmd cp $SRCDIR/files/records.config $DESTDIR/opt/ts/etc/records.config || \
        logerr "--- failed to install records.config"
}

make_install() {
    logmsg "--- make install"
    logcmd $MAKE DESTDIR=${DESTDIR} \
	pkgsysuser=$USER \
	pkgsysgroup=`groups | awk '{print $1;}'` \
	install || \
        	logerr "--- Make install failed"
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
install_method
install_manifest
install_config
make_package
clean_up
