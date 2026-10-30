# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
inherit flag-o-matic libtool toolchain-funcs

DESCRIPTION="UW IMAP c-client library"
HOMEPAGE="http://www.washington.edu/imap/"
SRC_URI="
https://deb.debian.org/debian/pool/main/u/uw-imap/uw-imap_2007f~dfsg.orig.tar.gz -> uw-imap_2007f~dfsg.orig.tar.gz
https://deb.debian.org/debian/pool/main/u/uw-imap/uw-imap_2007f~dfsg-7.debian.tar.xz -> uw-imap_2007f~dfsg-7.debian.tar.xz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
PATCHES=(
	"${FILESDIR}/c-client-2006k_GENTOO_Makefile.patch"
	"${FILESDIR}/c-client-2007f_GENTOO_amd64-so-fix.patch"
	"${FILESDIR}/c-client-2007f_p7-ldflags.patch"
	"${FILESDIR}/c-client-2007f-scandir-callback-types.patch"
	"${FILESDIR}/c-client-2007f_p7-implicit-declaration-fix.patch"
	"${FILESDIR}/c-client-2007f_p7-c99.patch"
)
IUSE="+ipv6 kerberos pam ssl static-libs"
REQUIRED_USE="static-libs? ( !pam )"
# Commons depends
CDEPEND="ssl? ( dev-libs/openssl:= )
	kerberos? ( virtual/krb5 )
	pam? ( sys-libs/pam )
	!pam? ( sys-libs/glibc )
	
"
RDEPEND="${CDEPEND}
"
DEPEND="${RDEPEND}
"
S="${WORKDIR}/imap-2007f~dfsg"
src_prepare() {
	# Apply the whole Debian patch series before the PATCHES= set
	# above: among other things it fixes OpenSSL 1.1+ autoverify,
	# TLS SNI and the krb5 multiarch link.
	eapply "${WORKDIR}"/debian/patches

	default

	# Tarball packed with bad file perms
	chmod -R u+rwX,go-w . || die "failed to fix permissions"

	# Lots of things need -fPIC, including various platforms, and
	# this library generally should be built with it anyway.
	append-flags -fPIC

	# Modifications so we can build it optimally and correctly
	sed \
		-e "s:BASECFLAGS=\".*\":BASECFLAGS=:g" \
		-e 's:SSLDIR=/usr/local/ssl:SSLDIR=/usr:g' \
		-e 's:SSLCERTS=$(SSLDIR)/certs:SSLCERTS=/etc/ssl/certs:g' \
		-i src/osdep/unix/Makefile \
		|| die "failed to fix compiler flags and SSL paths in the Makefile"

	# Make the build system more multilib aware
	sed \
		-e "s:^SSLLIB=\$(SSLDIR)/lib:SSLLIB=\$(SSLDIR)/$(get_libdir):" \
		-e "s:^AFSLIB=\$(AFSDIR)/lib:AFSLIB=\$(AFSDIR)/$(get_libdir):" \
		-i src/osdep/unix/Makefile \
		|| die "failed to fix our libdir in the Makefile"

	# Targets should use the linux fs
	sed -e '/^bsf:/,/^$/ s:ACTIVEFILE=.*:ACTIVEFILE=/var/lib/news/active:g' \
		-i src/osdep/unix/Makefile \
		|| die "failed to fix the FreeBSD ACTIVEFILE path in the Makefile"

	# Remove the pesky checks about SSL stuff
	sed -e '/read.*exit/d' -i Makefile \
		|| die "failed to disable SSL warning in the Makefile"

	sed -e "s:CC=cc:CC=$(tc-getCC):" \
		-e "s:ARRC=ar:ARRC=$(tc-getAR):" \
		-e "s:RANLIB=ranlib:RANLIB=$(tc-getRANLIB):" \
		-i src/osdep/unix/Makefile \
		|| die "failed to fix build flags support in the Makefile"

	sed -i -e "s:krb5-config.mit:krb5-config:" src/osdep/unix/Makefile.gss || die

	elibtoolize
}

src_compile() {
	local mymake target passwdtype

	local ipver='IP=4'
	if use ipv6 ; then
		ipver="IP=6"
		touch ip6 || die "failed to create ip6 file"
	fi

	local ssltype="none"
	if use ssl ; then
		ssltype="unix"
	fi

	# Fall back to "slx" when USE=pam is not set; this ensures
	# libcrypt is linked in to get the crypt() routine (the case
	# tracked upstream as bug #456928).
	if use pam ; then
		target=lnps passwdtype=pam
	else
		target=slx passwdtype=std
	fi

	if use kerberos ; then
		mymake="EXTRAAUTHENTICATORS=gss"
		EXTRALIBS="-lgssapi_krb5 -lkrb5 -lk5crypto -lcom_err"
	fi

	emake -j1 \
		SSLTYPE=${ssltype} ${target} \
		PASSWDTYPE=${passwdtype} ${ipver} ${mymake} \
		EXTRACFLAGS="${CFLAGS}" \
		EXTRALDFLAGS="${LDFLAGS}" \
		EXTRALIBS="${EXTRALIBS}" \
		GSSDIR=/usr
}

src_install() {
	if use static-libs; then
		# Library binary
		dolib.a c-client/c-client.a
		dosym c-client.a "/usr/$(get_libdir)/libc-client.a"
	fi

	# Now the shared library (built by the amd64-so-fix patch)
	dolib.so c-client/libc-client.so.1.0.0

	dosym libc-client.so.1.0.0 "/usr/$(get_libdir)/libc-client.so"
	dosym libc-client.so.1.0.0 "/usr/$(get_libdir)/libc-client.so.1"

	# Headers
	insinto /usr/include/imap
	doins src/osdep/unix/*.h
	doins src/c-client/*.h
	doins c-client/linkage.h
	doins c-client/linkage.c
	doins c-client/osdep.h

	if use ssl; then
		echo "  ssl_onceonlyinit ();" >> "${ED}"/usr/include/imap/linkage.c \
			|| die "failed to add ssl init statement to linkage.c"
	fi

	# Documentation
	dodoc README docs/*.txt docs/BUILD docs/CONFIG docs/RELNOTES docs/SSLBUILD
}


# vim: filetype=ebuild
