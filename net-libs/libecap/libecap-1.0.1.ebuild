# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="API for implementing ICAP content analysis and adaptation"
HOMEPAGE="http://www.e-cap.org"
SRC_URI="https://www.e-cap.org/archive/libecap-1.0.1.tar.gz -> libecap-1.0.1.tar.gz
"

LICENSE="BSD-2"
SLOT="1"
KEYWORDS="*"
IUSE="static-libs"

RDEPEND="!net-libs/libecap:0
	!net-libs/libecap:0.2"

DOCS=( CREDITS NOTICE README change.log )

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}