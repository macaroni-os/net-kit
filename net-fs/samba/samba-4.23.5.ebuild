# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
PYTHON_COMPAT=( python3+ )
WAF_BINARY="${S}/buildtools/bin/waf"
SHAREDMODS=""
inherit python-single-r1 systemd pam

DESCRIPTION="Samba Suite Version 4"
HOMEPAGE="https://samba.org/"
SRC_URI="https://download.samba.org/pub/samba/stable/samba-4.23.5.tar.gz -> samba-4.23.5.tar.gz"
LICENSE="GPL3"
SLOT="0"
KEYWORDS="*"
PATCHES=(
	"${FILESDIR}/ldb-2.5.2-skip-wav-tevent-check.patch"
)
IUSE="acl addc ads ceph client cluster cups debug dmapi fam glusterfs
gpg iprint json ldap pam profiling-data python quota +regedit
snapper spotlight syslog system-heimdal +system-mitkrb5 systemd winbind
zeroconf
"
REQUIRED_USE="${PYTHON_REQUIRED_USE}
addc? ( json python !system-mitkrb5 winbind )
ads? ( acl ldap python winbind )
cluster? ( ads )
gpg? ( addc )
ldap? ( ads )
spotlight? ( json )
!ads? ( !addc )
?? ( system-heimdal system-mitkrb5 )
"
BDEPEND="${PYTHON_DEPS}
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	virtual/pkgconfig
	
"
RDEPEND="app-arch/libarchive
	dev-lang/perl:=
	spotlight? ( dev-libs/icu:= )
	dev-libs/libbsd
	dev-libs/libtasn1
	dev-libs/popt
	dev-perl/Parse-Yapp
	net-libs/gnutls
	net-libs/libnsl
	net-libs/ngtcp2
	sys-libs/e2fsprogs-libs
	sys-libs/ldb[ldap(+)?]
	sys-libs/libcap
	sys-libs/liburing
	sys-libs/ncurses:0=
	sys-libs/readline:0=
	sys-libs/talloc
	sys-libs/tdb
	sys-libs/tevent
	sys-libs/zlib
	virtual/libiconv
	acl? ( virtual/acl )
	$(python_gen_cond_dep "
	  dev-python/subunit[\${PYTHON_USEDEP}]
	")
	systemd? ( sys-apps/systemd:= )
	ceph? ( sys-cluster/ceph )
	cluster? ( net-libs/rpcsvc-proto )
	cups? ( net-print/cups )
	debug? ( dev-util/lttng-ust )
	dmapi? ( sys-apps/dmapi )
	fam? ( virtual/fam )
	gpg? ( app-crypt/gpgme )
	json? ( dev-libs/jansson )
	ldap? ( net-nds/openldap )
	pam? ( sys-libs/pam )
	python? (
	  sys-libs/ldb[python,${PYTHON_USEDEP}]
	  sys-libs/talloc[python,${PYTHON_USEDEP}]
	  sys-libs/tdb[python,${PYTHON_USEDEP}]
	  sys-libs/tevent[python,${PYTHON_USEDEP}]
	)
	snapper? ( sys-apps/dbus )
	system-heimdal? ( >=app-crypt/heimdal-1.5[-ssl] )
	system-mitkrb5? ( >=app-crypt/mit-krb5-1.15.1 )
	zeroconf? ( net-dns/avahi[dbus] )
	client? ( net-fs/cifs-utils[ads?] )
	
"
DEPEND="${RDEPEND}
	dev-perl/JSON
	net-libs/libtirpc
	net-libs/rpcsvc-proto
	spotlight? ( dev-libs/glib )
	
"
pkg_setup() {
	export DISTCC_DISABLE=1
	python-single-r1_pkg_setup
	SHAREDMODS="$(usex snapper '' '!')vfs_snapper"
	if use cluster ; then
	  SHAREDMODS+=",idmap_rid,idmap_tdb2,idmap_ad"
	elif use ads ; then
	  SHAREDMODS+=",idmap_ad"
	fi
}
src_prepare() {
	default
	# un-bundle dnspython
	sed -i -e '/"dns.resolver":/d' "${S}"/third_party/wscript || die
	# unbundle iso8601 unless tests are enabled
	sed -i -e '/"iso8601":/d' "${S}"/third_party/wscript || die
	sed -e 's:<gpgme\.h>:<gpgme/gpgme.h>:' \
	  -i source4/dsdb/samdb/ldb_modules/password_hash.c \
	  || die
}
src_configure() {
	# when specifying libs for samba build you must append NONE to the end to
	# stop it automatically including things
	local bundled_libs="NONE"
	if ! use system-heimdal && ! use system-mitkrb5 ; then
	  bundled_libs="heimbase,heimntlm,hdb,kdc,krb5,wind,gssapi,hcrypto,hx509,roken,asn1,com_err,NONE"
	fi
	 bundled_libs="libquic,${bundled_libs}"
	 local myconf=(
	  --enable-fhs
	  --sysconfdir="${EPREFIX}/etc"
	  --localstatedir="${EPREFIX}/var"
	  --with-modulesdir="${EPREFIX}/usr/$(get_libdir)/samba"
	  --with-piddir="${EPREFIX}/run/${PN}"
	  --bundled-libraries="${bundled_libs}"
	  --builtin-libraries=NONE
	  --disable-rpath
	  --disable-rpath-install
	  --nopyc
	  --nopyo
	  --without-winexe
	  $(use_with acl acl-support)
	  $(usex addc '' '--without-ad-dc')
	  $(use_with ads)
	  $(use_enable ceph cephfs)
	  $(use_with cluster cluster-support)
	  $(use_enable cups)
	  $(use_with dmapi)
	  $(use_with fam)
	  $(use_enable glusterfs)
	  $(use_with gpg gpgme)
	  $(use_with json)
	  $(use_enable iprint)
	  $(use_with pam)
	  $(usex pam "--with-pammodulesdir=${EPREFIX}/$(get_libdir)/security" '')
	  $(use_with quota quotas)
	  $(use_with regedit)
	  $(use_enable spotlight)
	  $(use_with syslog)
	  $(use_with winbind)
	  $(usex python '' '--disable-python')
	  $(use_enable zeroconf avahi)
	  $(usex system-mitkrb5 "--with-system-mitkrb5 $(usex addc --with-experimental-mit-ad-dc '')" '')
	  $(use_with debug lttng)
	  $(use_with ldap)
	  $(use_with profiling-data)
	  --with-shared-modules=${SHAREDMODS}
	  --jobs 1
	)
	 if use systemd ; then
	  myconf+=(
	    --systemd-install-services
	    --with-systemddir="$(systemd_get_systemunitdir)"
	  )
	fi
	CPPFLAGS="-I${SYSROOT}${EPREFIX}/usr/include/et ${CPPFLAGS}" \
	  econf ${myconf[@]}
}
src_install() {
	emake DESTDIR="${ED}" install
	# Make all .so files executable
	find "${ED}" -type f -name "*.so" -exec chmod +x {} + || die
	# install ldap schema for server (bug #491002)
	if use ldap ; then
	  insinto /etc/openldap/schema
	  doins examples/LDAP/samba.schema
	fi
	# create symlink for cups (bug #552310)
	if use cups ; then
	  dosym ../../../bin/smbspool /usr/libexec/cups/backend/smb
	fi
	# install example config file
	insinto /etc/samba
	doins examples/smb.conf.default
	# Fix paths in example file (#603964)
	sed \
	  -e '/log file =/s@/usr/local/samba/var/@/var/log/samba/@' \
	  -e '/include =/s@/usr/local/samba/lib/@/etc/samba/@' \
	  -e '/path =/s@/usr/local/samba/lib/@/var/lib/samba/@' \
	  -e '/path =/s@/usr/local/samba/@/var/lib/samba/@' \
	  -e '/path =/s@/usr/spool/samba@/var/spool/samba@' \
	  -i "${ED}"/etc/samba/smb.conf.default || die
	# Install init script and conf.d file
	if use systemd ; then
	  if ! use addc ; then
	    rm "${D}/$(systemd_get_systemunitdir)/samba.service"
	  fi
	else
	  newinitd "${FILESDIR}/samba4.initd-r1" samba
	fi
	newconfd "${FILESDIR}/samba4.confd" samba
	if use pam && use winbind ; then
	  newpamd "${FILESDIR}/system-auth-winbind.pam" system-auth-winbind
	  # bugs #376853 and #590374
	  insinto /etc/security
	  doins examples/pam_winbind/pam_winbind.conf
	fi
	 # Remove libdb files available in the sys-libs/libdb package
	einfo "Removing files owned by sys-libs/libdb package..."
	rm "${D}"/usr/bin/ldb* -v
	rm "${D}"/usr/lib/python*/site-packages/{_ldb_*,ldb.cpython*} -v
	rm "${D}"/usr/lib64/pkgconfig/ldb.pc -v
	rm "${D}"/usr/lib64/samba/ldb/ -rfv
	rm "${D}"/usr/share/man/man1/ldb* -v
	rm "${D}"/usr/share/man/man3/ldb.* -v
	 keepdir /var/cache/samba
	keepdir /var/lib/ctdb
	keepdir /var/lib/samba/{bind-dns,private}
	keepdir /var/lock/samba
	keepdir /var/log/samba
}


# vim: filetype=ebuild
