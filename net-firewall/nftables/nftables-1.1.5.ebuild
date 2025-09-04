# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
inherit autotools

DESCRIPTION="Modern Linux kernel packet classification framework"
HOMEPAGE="https://netfilter.org/projects/nftables/"
SRC_URI="https://www.netfilter.org/pub/nftables/nftables-1.1.5.tar.xz -> nftables-1.1.5.tar.xz"
SLOT="0"
KEYWORDS="*"
IUSE="debug +cli doc +gmp json +modern_kernel python xtables"
RDEPEND="net-libs/libmnl
	gmp? ( dev-libs/gmp:0= )
	json? ( dev-libs/jansson )
	cli? ( dev-libs/libedit:0= )
	>=net-libs/libnftnl-1.2.9
	
"
DEPEND="${RDEPEND}
	app-text/docbook2X
	doc? ( app-text/dblatex )
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
	
"
src_prepare() {
	default
	eautoreconf
}
src_configure() {
	local myeconfargs=(
	  --sbindir="${EPREFIX}"/sbin
	  $(use_enable python)
	  $(use_enable debug)
	  $(use_enable doc man-doc)
	  $(use_with !gmp mini_gmp)
	  $(use_with json)
	  $(use_with xtables)
	  $(if use !cli; then use_with cli; fi)
	)
	econf "${myeconfargs[@]}"
}
src_install() {
	default
	local mksuffix=""
	use modern_kernel && mksuffix="-mk"
	exeinto /usr/libexec/${PN}
	newexe "${FILESDIR}"/libexec/${PN}${mksuffix}.sh ${PN}.sh
	newconfd "${FILESDIR}"/${PN}${mksuffix}.confd ${PN}
	newinitd "${FILESDIR}"/${PN}${mksuffix}.init ${PN}
	keepdir /var/lib/nftables
	docinto /usr/share/doc/${PF}/skels
	dodoc -r "${D}"/etc/nftables/*
	rm -R "${D}"/etc/nftables
}
pkg_postinst() {
	local save_file
	save_file="${EROOT%/}/var/lib/nftables/rules-save"
	# In order for the nftables-restore systemd service to start
	# the save_file must exist.
	if [[ ! -f ${save_file} ]]; then
	  touch ${save_file}
	fi
	elog "If you are creating firewall rules before the next system restart "
	elog "the nftables-restore service must be manually started in order to "
	elog "save those rules on shutdown."
}


# vim: filetype=ebuild
