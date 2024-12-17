# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A routing daemon implementing OSPF, RIPv2 & BGP for IPv4 & IPv6"
HOMEPAGE="http://bird.network.cz"
SRC_URI="https://github.com/CZ-NIC/bird/tarball/e7bd976178a2b133c36492420c0ad0455253f81e -> bird-3.0.0-e7bd976.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="*"
IUSE="+client debug"

S="${WORKDIR}/CZ-NIC-bird-e7bd976"

RDEPEND="client? ( sys-libs/ncurses )
	client? ( sys-libs/readline )"
DEPEND="sys-devel/flex
	sys-devel/bison
	sys-devel/m4"

src_prepare() {
    default
    eautoreconf
}

src_configure() {
	econf \
		--localstatedir="${EPREFIX}/var" \
		$(use_enable client) \
		$(use_enable debug)
}

src_install() {
	if use client; then
		dobin birdc
	fi
	dobin birdcl
	dosbin bird
	newinitd "${FILESDIR}/initd-${PN}-2" bird
	dodoc doc/bird.conf.example
}
