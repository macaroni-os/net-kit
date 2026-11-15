# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
PYTHON_COMPAT=( python3+ )
inherit autotools python-single-r1 systemd tmpfiles

DESCRIPTION="Production quality, multilayer virtual switch"
HOMEPAGE="https://www.openvswitch.org"
SRC_URI="https://api.github.com/repos/openvswitch/ovs/tarball/refs/tags/v4.0.0 -> openvswitch-4.0.0-b89dc80.tar.gz"
LICENSE="Apache-2.0 GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="debug monitor +ssl systemd unwind"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
# Commons depends
CDEPEND="ssl? ( dev-libs/openssl:0= )
	unwind? ( sys-libs/libunwind:= )
	
"
BDEPEND="virtual/pkgconfig
	
"
RDEPEND="${CDEPEND}
	${PYTHON_DEPS}
	dev-python/ovs[${PYTHON_USEDEP}]
	dev-python/twisted[conch,${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]
	net-dns/unbound
	sys-libs/libcap-ng
	debug? ( dev-lang/perl )
	
"
DEPEND="${RDEPEND}
	sys-apps/util-linux[caps]
	
"

post_src_unpack() {
	mv openvswitch-ovs-* ${S}
}


pkg_setup() {
	python-single-r1_pkg_setup
}
src_prepare() {
	default
	eautoreconf
}
src_configure() {
	# flake8 is primarily a style guide tool: running it as part of the
	# build only breaks it (Gentoo bug 607280).
	export ovs_cv_flake8="no"
	# Skip the man-page diagram; it would need graphviz (Gentoo bug 856286).
	export ovs_cv_dot="no"
	export PYTHON3="${PYTHON}"
	export ac_cv_lib_unwind_unw_backtrace=$(usex unwind)
	 local myeconfargs=(
	  --with-rundir=/run/openvswitch
	  --with-logdir=/var/log/openvswitch
	  --with-pkidir=/etc/ssl/openvswitch
	  --with-dbdir=/var/lib/openvswitch
	  --enable-libcapng
	  $(use_enable ssl)
	  $(use_enable !debug ndebug)
	)
	econf "${myeconfargs[@]}"
}
src_install() {
	default
	 local script
	if use monitor ; then
	  # The set of shipped Python helpers changes across OVS releases
	  # (4.0 dropped ovs-parse-backtrace/l3ping/test/vlan-test and
	  # bugtool/ovs-bugtool): install whichever utilities/ovs-* helper
	  # carries a Python shebang in this release.
	  for script in utilities/ovs-* ; do
	    [[ -f "${script}" ]] || continue
	    [[ "$(head -n 1 "${script}")" == *python* ]] || continue
	    python_doscript "${script}"
	  done
	  rm -r "${ED}"/usr/share/openvswitch/python || die
	fi
	 keepdir /var/{lib,log}/openvswitch
	keepdir /etc/openvswitch
	keepdir /etc/ssl/openvswitch
	fperms 0750 /etc/ssl/openvswitch
	 rm -rf "${ED}"/var/run || die
	 # The systemd units keep EnvironmentFile=-/etc/conf.d/<service>, so
	# the same knobs work for both init systems.
	newconfd "${FILESDIR}/ovsdb-server.confd" ovsdb-server
	newconfd "${FILESDIR}/ovs-vswitchd.confd" ovs-vswitchd
	 if use systemd ; then
	  systemd_newunit "${FILESDIR}/ovsdb-server.service" ovsdb-server.service
	  systemd_newunit "${FILESDIR}/ovs-vswitchd.service" ovs-vswitchd.service
	  systemd_newunit rhel/usr_lib_systemd_system_ovs-delete-transient-ports.service ovs-delete-transient-ports.service
	  newtmpfiles "${FILESDIR}/openvswitch.tmpfiles" openvswitch.conf
	else
	  newinitd "${FILESDIR}/ovsdb-server.initd" ovsdb-server
	  newinitd "${FILESDIR}/ovs-vswitchd.initd" ovs-vswitchd
	fi
	 insinto /etc/logrotate.d
	newins rhel/etc_logrotate.d_openvswitch openvswitch
}
pkg_postinst() {
	if use systemd ; then
	  tmpfiles_process openvswitch.conf
	fi
	 elog "Use the following command to create an initial database for ovsdb-server:"
	elog "   emerge --config =${CATEGORY}/${PF}"
	elog "(will create a database in /var/lib/openvswitch/conf.db)"
	elog "or to convert the database to the current schema after upgrading."
}
pkg_config() {
	local db="${EROOT}/var/lib/openvswitch/conf.db"
	if [[ -e "${db}" ]] ; then
	  einfo "Database '${db}' already exists, doing schema migration..."
	  einfo "(if the migration fails, make sure that ovsdb-server is not running)"
	  ovsdb-tool convert "${db}" \
	    "${EROOT}/usr/share/openvswitch/vswitch.ovsschema" || die "converting database failed"
	else
	  einfo "Creating new database '${db}'..."
	  ovsdb-tool create "${db}" \
	    "${EROOT}/usr/share/openvswitch/vswitch.ovsschema" || die "creating database failed"
	fi
}



# vim: filetype=ebuild
