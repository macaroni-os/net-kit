# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
inherit autotools ltprune

DESCRIPTION="ENet reliable UDP networking library "
HOMEPAGE="https://github.com/lsalzman/enet"
SRC_URI="https://api.github.com/repos/lsalzman/enet/tarball/refs/tags/v1.3.18 -> enet-1.3.18-2662c0d.tar.gz"
LICENSE="MIT"
SLOT="1.3"
KEYWORDS="*"
IUSE="static-libs"

post_src_unpack() {
	mv lsalzman-enet-* ${S}
}


src_prepare() {
	default
	eautoreconf --force
}
src_configure() {
	econf $(use_enable static-libs static)
}
src_install() {
	default
	prune_libtool_files
}



# vim: filetype=ebuild
