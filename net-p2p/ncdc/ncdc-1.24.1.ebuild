# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Lightweight direct connect client with a friendly ncurses interface"
HOMEPAGE="https://dev.yorhel.nl/ncdc"
SRC_URI="https://dev.yorhel.nl/download/ncdc-1.24.1.tar.gz -> ncdc-1.24.1.tar.gz"
KEYWORDS="*"

LICENSE="MIT"
SLOT="0"
IUSE="geoip"

RDEPEND="
	app-arch/bzip2
	dev-db/sqlite:3
	dev-libs/glib
	>=net-libs/gnutls-3:=
	sys-libs/ncurses:=
	sys-libs/zlib
	geoip? ( dev-libs/libmaxminddb:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	dev-lang/perl
"

src_configure() {
	local myeconfargs=(
		$(use_with geoip)
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	emake AR="$(tc-getAR)"
}