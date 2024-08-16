# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools linux-info

DESCRIPTION="Programming interface (API) to the in-kernel connection tracking state table"
HOMEPAGE="https://www.netfilter.org/projects/libnetfilter_conntrack/"
SRC_URI="https://www.netfilter.org/pub/libnetfilter_conntrack/libnetfilter_conntrack-1.0.9.tar.bz2 -> libnetfilter_conntrack-1.0.9.tar.bz2
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

RDEPEND=">=net-libs/libmnl-1.0.3
	>=net-libs/libnfnetlink-1.0.0"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( README )

#PATCHES=(
#	"${FILESDIR}"/${P}-musl.patch
#	"${FILESDIR}"/${PN}-1.0.9-configure-clang16.patch
#)

pkg_setup() {
	linux-info_pkg_setup

	if kernel_is lt 2 6 18 ; then
		die "${PN} requires at least 2.6.18 kernel version"
	fi

	# netfilter core team has changed some option names with kernel 2.6.20
	if kernel_is lt 2 6 20 ; then
		CONFIG_CHECK="~IP_NF_CONNTRACK_NETLINK"
	else
		CONFIG_CHECK="~NF_CT_NETLINK"
	fi

	check_extra_config
}

src_prepare() {
	default

	# autoreconf only for clang 16 configure patch
	eautoreconf
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}

# vim: noet ts=4 syn=ebuild