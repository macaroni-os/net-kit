# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
inherit autotools

DESCRIPTION="ngtcp2 project is an effort to implement IETF QUIC protocol"
HOMEPAGE="https://nghttp2.org/ngtcp2/"
SRC_URI="https://api.github.com/repos/ngtcp2/ngtcp2/tarball/v1.25.0 -> ngtcp2-1.25.0-f9e9ff0.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE="+gnutls openssl +ssl"
REQUIRED_USE="ssl? ( || ( gnutls openssl ) )
"
BDEPEND="virtual/pkgconfig
	
"
RDEPEND="ssl? (
	  gnutls? ( net-libs/gnutls:= )
	  openssl? ( dev-libs/openssl:= )
	)
	
"
DEPEND="${RDEPEND}
"

post_src_unpack() {
	mv ngtcp2-ngtcp2-* ${S}
}


src_prepare() {
	default
	eautoreconf
}
src_configure() {
	local myeconfargs=(
	  --disable-werror
	  --enable-lib-only
	  $(use_with openssl)
	  $(use_with gnutls)
	  --without-boringssl
	  --without-picotls
	  --without-wolfssl
	  --without-libev
	  --without-libnghttp3
	  --without-jemalloc
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}
src_install() {
	default
	einstalldocs
	find "${ED}"/usr -type f -name '*.la' -delete || die
}



# vim: filetype=ebuild
