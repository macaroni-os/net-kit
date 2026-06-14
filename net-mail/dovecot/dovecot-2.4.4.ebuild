# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
inherit autotools ssl-cert systemd toolchain-funcs user

DESCRIPTION="An IMAP and POP3 server written with security primarily in mind"
HOMEPAGE="https://www.dovecot.org/"
SRC_URI="
https://www.dovecot.org/releases/2.4/dovecot-2.4.4.tar.gz -> dovecot-2.4.4.tar.gz
sieve? ( https://pigeonhole.dovecot.org/releases/2.4/dovecot-pigeonhole-2.4.4.tar.gz -> dovecot-pigeonhole-2.4.4.tar.gz )"
LICENSE="LPGL-2.1 MIT"
SLOT="0"
KEYWORDS="*"
IUSE="kerberos ldap lua mysql pam postgres sqlite
bzip2 lzma lz4 zlib zstd argon2 caps ipv6
lucene sieve rpc solr static-libs suid
tcpd textcat unwind systemd
"
# Commons depends
CDEPEND="argon2? ( dev-libs/libsodium )
	bzip2? ( app-arch/bzip2 )
	caps? ( sys-libs/libcap )
	kerberos? ( virtual/krb5 )
	ldap? ( net-nds/openldap )
	lua? ( dev-lang/lua:= )
	lucene? ( dev-cpp/clucene )
	lzma? ( app-arch/xz-utils )
	lz4? ( app-arch/lz4 )
	mysql? ( dev-db/mysql-connector-c:= )
	pam? ( sys-libs/pam )
	postgres? ( dev-db/postgresql )
	rpc? (
	  net-libs/libtirpc
	  net-libs/rpcsvc-proto
	)
	solr? (
	  net-misc/curl
	  dev-libs/expat
	)
	sqlite? ( dev-db/sqlite )
	dev-libs/openssl
	tcpd? ( sys-apps/tcp-wrappers )
	textcat? ( app-text/libexttextcat )
	unwind? ( sys-libs/libunwind )
	zlib? ( sys-libs/zlib )
	zstd? ( app-arch/zstd )
	virtual/libiconv
	dev-libs/icu:=
	
"
BDEPEND="virtual/pkgconfig
	
"
RDEPEND="${CDEPEND}
	net-mail/mailbase
	
"
DEPEND="${CDEPEND}
"
pkg_setup() {
	# default internal user
	enewgroup dovecot 97
	enewuser dovecot 97 -1 /dev/null dovecot
	# default login user
	enewuser dovenull -1 -1 /dev/null
	# add "mail" group for suid'ing. Better security isolation.
	if use suid; then
	  enewgroup mail
	fi
}
src_prepare() {
	default
	# unix socket path too long under portage build dir
	sed -i '/^TEST_IMAP_CLIENT_HIBERNATE/s/test-imap-client-hibernate//' src/imap/Makefile.am || die
	# rename default cert files
	sed -i -e "s:ssl-cert.pem:server.pem:" \
	  -e "s:ssl-key.pem:server.key:" \
	  doc/dovecot.conf.in || die "sed failed"
	#elibtoolize
	eautoreconf
	append-cflags -fasynchronous-unwind-tables
	append-cflags -fno-strict-aliasing
}
src_configure() {
	local conf=""
	 if use postgres || use mysql || use sqlite; then
	  conf="${conf} --with-sql"
	fi
	 # turn valgrind tests off. Bug #340791
	VALGRIND=no econf \
	  --with-rundir="/run/dovecot" \
	  --with-statedir="/var/lib/dovecot" \
	  --with-moduledir="/usr/$(get_libdir)/dovecot" \
	  --without-stemmer \
	  --disable-rpath \
	  --without-libbsd \
	  --with-icu \
	  --with-ssl \
	  --with-systemdsystemunitdir="$(systemd_get_systemunitdir)" \
	  $( use_with argon2 sodium ) \
	  $( use_with bzip2 bzlib ) \
	  $( use_with caps libcap ) \
	  $( use_with kerberos gssapi ) \
	  $( use_with lua ) \
	  $( use_with ldap ) \
	  $( use_with lucene ) \
	  $( use_with lz4 ) \
	  $( use_with lzma ) \
	  $( use_with mysql ) \
	  $( use_with pam ) \
	  $( use_with postgres pgsql ) \
	  $( use_with sqlite ) \
	  $( use_with solr ) \
	  $( use_with tcpd libwrap ) \
	  $( use_with textcat ) \
	  $( use_with unwind libunwind ) \
	  $( use_with zlib ) \
	  $( use_with zstd ) \
	  $( use_with systemd ) \
	  $( use_enable static-libs static ) \
	  ${conf}
	if use sieve ; then
	  # The sieve plugin needs this file to be build to determine the plugin
	  # directory and the list of libraries to link to.
	  emake dovecot-config
	  cd "../dovecot-pigeonhole-2.4.4" || die "cd failed"
	  econf \
	    $( use_enable static-libs static ) \
	    --localstatedir="/var" \
	    --enable-shared \
	    --with-dovecot="${S}" \
	    $( use_with sieve )
	fi
}
src_compile() {
	default
	if use sieve ; then
	  pushd "../dovecot-pigeonhole-2.4.4" > /dev/null || die
	  emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
	  popd > /dev/null || die
	fi
}
src_install() {
	default
	if use suid; then
	  einfo "Changing perms to allow deliver to be suided"
	  fowners root:mail "/usr/libexec/dovecot/dovecot-lda"
	  fperms 4750 "/usr/libexec/dovecot/dovecot-lda"
	fi
	if ! use systemd ; then
	  newinitd "${FILESDIR}"/dovecot.init-r6 dovecot
	fi
	use pam && dosym imap /etc/pam.d/dovecot
	 insinto /etc/dovecot/conf.d
	doins "${FILESDIR}/50-misc.conf"
	 dodoc AUTHORS NEWS README.md TODO
	 if use sieve ; then
	  pushd "${PIEGONHOLE_S}" > /dev/null || die
	  emake DESTDIR="${ED}" install
	   newdoc README README.pigeonhole
	  popd > /dev/null || die
	fi
	 if use static-libs; then
	  strip-lto-bytecode
	else
	  find "${ED}"/usr/lib* -name '*.la' -delete
	fi
}
pkg_postinst() {
	# Let's not make a new certificate if we already have one
	if ! [[ -e "${ROOT}"/etc/dovecot/server.pem && \
	  -e "${ROOT}"/etc/dovecot/server.key ]];	then
	  einfo "Creating SSL	certificate"
	  SSL_ORGANIZATION="${SSL_ORGANIZATION:-Dovecot IMAP Server}"
	  install_cert /etc/dovecot/server
	fi
}


# vim: filetype=ebuild
