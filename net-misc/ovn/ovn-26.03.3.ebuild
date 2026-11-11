# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
PYTHON_COMPAT=( python3+ )
inherit autotools python-single-r1 systemd

DESCRIPTION="Open Virtual Network"
HOMEPAGE="https://www.ovn.org/"
SRC_URI="
https://api.github.com/repos/ovn-org/ovn/tarball/refs/tags/v26.03.3 -> ovn-26.03.3-4c5118f.tar.gz
mirror://macaroni/ovn-26.03.3-mark-gitsubmodules-bundle-4c5118f.tar.xz -> ovn-26.03.3-mark-gitsubmodules-bundle-4c5118f.tar.xz"
LICENSE="Apache-2.0 GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="+dns +ssl systemd"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
BDEPEND="virtual/pkgconfig
	
"
RDEPEND="${PYTHON_DEPS}
	dev-libs/openssl:=
	net-misc/openvswitch
	sys-libs/libcap-ng
	dns? ( net-dns/unbound )
	
"
DEPEND="${RDEPEND}
	
"
src_unpack() {
	default

	# The gitsubmodules bundle is always unpacked under pkg_basedir.
	# For an annotated tag the default source tarball unpacks under the
	# tag-object sha instead, so two roots can be present: move the
	# bundle's ovs/ aside and keep the source tree.  With a lightweight
	# tag both share one root and the ovs/ tree is already merged.
	local bundle="${WORKDIR}/ovn-org-ovn-4c5118f"
	local roots=( "${WORKDIR}"/ovn-org-ovn-* )

	if [[ ${#roots[@]} -eq 1 ]] ; then
		mv "${roots[0]}" "${S}" || die
	else
		mv "${bundle}/ovs" "${WORKDIR}/ovs" || die
		rm -rf "${bundle}" || die
		mv "${WORKDIR}"/ovn-org-ovn-* "${S}" || die
		rm -rf "${S}/ovs"
		mv "${WORKDIR}/ovs" "${S}/ovs" || die
	fi
}
src_prepare() {
	default

	pushd "${S}/ovs" >/dev/null || die
	./boot.sh || die
	popd >/dev/null || die
	./boot.sh || die
}
src_configure() {
	pushd "${S}/ovs" >/dev/null || die
	econf \
		--with-pkidir=/etc/ssl/openvswitch \
		--enable-libcapng \
		--enable-ssl \
		PYTHON3="${PYTHON}" || die
	popd >/dev/null || die

	# OVN_CHECK_UNBOUND autodetects libunbound; pin it to the USE flag
	# so USE=-dns really builds without the dependency.
	export ac_cv_lib_unbound_ub_ctx_create=$(usex dns)

	local myeconfargs=(
		--with-ovs-source="${S}/ovs"
		--with-ovs-build="${S}/ovs"
		--with-rundir=/run/ovn
		--with-dbdir=/var/lib/ovn
		--with-logdir=/var/log/ovn
		--with-pkidir=/etc/ssl/ovn
		--enable-libcapng
		$(use_enable ssl)
	)
	econf "${myeconfargs[@]}" PYTHON3="${PYTHON}"
}
src_compile() {
	pushd "${S}/ovs" >/dev/null || die
	emake
	popd >/dev/null || die
	emake
}
src_install() {
	default

	# Upstream installs the man-page helper as ovn_detrace.py.
	mv "${ED}/usr/bin/ovn_detrace.py" "${ED}/usr/bin/ovn-detrace" || die

	keepdir /var/{lib,log}/ovn
	keepdir /etc/ssl/ovn
	fperms 0750 /etc/ssl/ovn

	insinto /etc/logrotate.d
	newins rhel/etc_logrotate.d_ovn ovn

	# ovn-central starts the northbound and southbound OVSDB servers
	# plus ovn-northd (the Ubuntu/geaaru overlay layout LXD/Incus
	# expects); ovn-controller is the per-host daemon.  The extra
	# vtep/IC units are shipped too, as in the overlay.
	newconfd "${FILESDIR}/ovn-central.confd" ovn-central
	newconfd "${FILESDIR}/ovn-north.confd" ovn-north
	newconfd "${FILESDIR}/ovn-south.confd" ovn-south
	newconfd "${FILESDIR}/ovn-controller.confd" ovn-controller
	newconfd "${FILESDIR}/ovn-controller-vtep.confd" ovn-controller-vtep
	newconfd "${FILESDIR}/ovn-ic.confd" ovn-ic
	newconfd "${FILESDIR}/ovn-ic-ovsdb.confd" ovn-ic-ovsdb

	if use systemd ; then
		systemd_dounit "${FILESDIR}/ovn-central.service"
		systemd_dounit "${FILESDIR}/ovn-north.service"
		systemd_dounit "${FILESDIR}/ovn-south.service"
		systemd_dounit "${FILESDIR}/ovn-controller.service"
		systemd_dounit "${FILESDIR}/ovn-controller-vtep.service"
		systemd_dounit "${FILESDIR}/ovn-ic.service"
		systemd_dounit "${FILESDIR}/ovn-ic-ovsdb.service"
	else
		newinitd "${FILESDIR}/ovn-central.initd" ovn-central
		newinitd "${FILESDIR}/ovn-north.initd" ovn-north
		newinitd "${FILESDIR}/ovn-south.initd" ovn-south
		newinitd "${FILESDIR}/ovn-controller.initd" ovn-controller
		newinitd "${FILESDIR}/ovn-controller-vtep.initd" ovn-controller-vtep
		newinitd "${FILESDIR}/ovn-ic.initd" ovn-ic
		newinitd "${FILESDIR}/ovn-ic-ovsdb.initd" ovn-ic-ovsdb
	fi
}


# vim: filetype=ebuild
