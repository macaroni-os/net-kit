# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools

DESCRIPTION="High-level C binding for ØMQ"
HOMEPAGE="http://czmq.zeromq.org"
SRC_URI="https://github.com/zeromq/czmq/tarball/92897440df667c205289a5dea32769ec67eda14e -> czmq-4.2.1-9289744.tar.gz"

LICENSE="MPL-2.0"
SLOT="0/4"
KEYWORDS="*"
IUSE="curl drafts http-client http-server lz4 nss static-libs systemd +uuid"

BDEPEND="app-text/asciidoc
	app-text/xmlto
	virtual/pkgconfig"

RDEPEND=">=net-libs/zeromq-4:=[drafts?]
	http-client? ( net-misc/curl )
	http-server? ( net-libs/libmicrohttpd:= )
	lz4? ( app-arch/lz4:= )
	nss? (
		dev-libs/nspr
		dev-libs/nss
	)
	uuid? ( sys-apps/util-linux:0 )"

DEPEND="${RDEPEND}"

DOCS=( AUTHORS NEWS README.md )

post_src_unpack() {
	if [ ! -d "${S}" ]; then
		mv zeromq-czmq* "${S}" || die
	fi
}

src_prepare() {
	eautoreconf
	default
}

src_configure() {
	local myeconfargs=(
		--enable-drafts=$(usex drafts)
		--with-docs=no
		--with-uuid=$(usex uuid)
		--with-libcurl=$(usex http-client)
		--with-libmicrohttpd=$(usex http-server)
		--with-libsystemd=$(usex systemd)
		--with-liblz4=$(usex lz4)
		--with-nss=$(usex nss)
	)
	
	econf ${myeconfargs} || die
}