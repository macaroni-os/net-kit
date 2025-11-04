# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
# configurable from outside, e.g. /etc/portage/make.conf
IP_NF_SET_MAX=${IP_NF_SET_MAX:-256}

inherit linux-info ltprune

DESCRIPTION="IPset tool for iptables, successor to ippool"
HOMEPAGE="https://netfilter.org/projects/ipset/ http://ipset.netfilter.org/"
SRC_URI="https://www.netfilter.org/pub/ipset/ipset-7.24.tar.bz2 -> ipset-7.24.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
DOCS=(
	ChangeLog
	INSTALL
	README
	UPGRADE
)
RDEPEND="net-firewall/iptables
	net-libs/libmnl
	
"
DEPEND="${RDEPEND}
"
src_configure() {
	econf \
	  --without-kmod
	  --with-maxsets=${IP_NF_SET_MAX} \
	  --libdir="${EPREFIX}/$(get_libdir)" \
	  --with-ksource="${KV_DIR}" \
	  --with-kbuild="${KV_OUT_DIR}"
}
src_compile() {
	einfo "Building userspace"
	emake
}
src_install() {
	einfo "Installing userspace"
	default
	prune_libtool_files
	newinitd "${FILESDIR}"/ipset.initd-r4 ${PN}
	newconfd "${FILESDIR}"/ipset.confd ${PN}
	keepdir /var/lib/ipset
	if [[ ${build_modules} -eq 1 ]]; then
	  einfo "Installing kernel modules"
	  linux-mod_src_install
	fi
}


# vim: filetype=ebuild
