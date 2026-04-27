# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
inherit autotools

DESCRIPTION="Yeraze's TNEF Stream Reader - for winmail.dat files"
HOMEPAGE="https://github.com/Yeraze/ytnef"
SRC_URI="https://api.github.com/repos/Yeraze/ytnef/tarball/refs/tags/v2.1.2 -> ytnef-2.1.2-d9f0891.tar.gz"
LICENSE="GPL-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="static-libs"
RDEPEND="sys-devel/libtool
	dev-perl/MIME-tools
	
"

post_src_unpack() {
	mv Yeraze-ytnef-* ${S}
}


src_prepare() {
	default
	eautoreconf
}
src_configure() {
	econf $(use_enable static-libs static)
}
src_install() {
	default
	find "${ED}" -name "*.la" -delete || die
}



# vim: filetype=ebuild
