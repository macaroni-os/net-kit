# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
PYTHON_COMPAT=( python3+ )
LUA_COMPAT=( lua5-3 )
LUA_REQ_USE="deprecated"
inherit autotools flag-o-matic lua-single distutils-r1 toolchain-funcs

DESCRIPTION="Network exploration tool and security / port scanner"
HOMEPAGE="https://nmap.org/"
SRC_URI="https://nmap.org/dist/nmap-7.993.tar.bz2 -> nmap-7.993.tar.bz2"
LICENSE="|| ( NPSL GPL-2 )"
SLOT="0"
KEYWORDS="*"
PATCHES=(
	"${FILESDIR}/nmap-liblua-ar.patch"
)
IUSE="ipv6 libssh2 ncat nping +nse ssl +system-lua"
REQUIRED_USE="system-lua? ( nse ${LUA_REQUIRED_USE} )
"
RDEPEND="dev-libs/liblinear:=
	dev-libs/libpcre
	net-libs/libpcap
	libssh2? (
	  net-libs/libssh2[zlib]
	  sys-libs/zlib
	)
	nse? ( sys-libs/zlib )
	ssl? ( dev-libs/openssl:= )
	system-lua? ( ${LUA_DEPS} )
	
"
DEPEND="${RDEPEND}
"
pkg_setup() {
	use system-lua && lua-single_pkg_setup
}
src_prepare() {
	rm -r liblinear/ libpcap/ libpcre/ libssh2/ libz/ || die

	cat "${FILESDIR}"/nls.m4 >> "${S}"/acinclude.m4 || die

	default

	sed -i \
		-e '/^ALL_LINGUAS =/{s|$| id|g;s|jp|ja|g}' \
		Makefile.in || die

	cp libdnet-stripped/include/config.h.in{,.nmap-orig} || die

	eautoreconf
}
src_configure() {
	export ac_cv_path_PYTHON="${PYTHON}"
	export am_cv_pathless_PYTHON="${EPYTHON}"

	python_setup

	# The bundled libdnet is incompatible with the version available in the
	# tree, so we cannot use the system library here.
	econf \
		$(use_enable ipv6) \
		$(use_with libssh2) \
		$(use_with ncat) \
		$(use_with nping) \
		$(use_with ssl openssl) \
		$(usex libssh2 --with-zlib) \
		$(usex nse --with-liblua=$(usex system-lua yes included '' '') --without-liblua) \
		$(usex nse --with-zlib) \
		--cache-file="${S}"/config.cache \
		--with-libdnet=included \
		--with-pcre=/usr \
		--without-ndiff \
		--without-zenmap
}
src_compile() {
	local directory
	for directory in . libnetutil nsock/src \
		$(usex ncat ncat '') \
		$(usex nping nping '')
	do
		emake -C "${directory}" makefile.dep
	done

	emake \
		AR=$(tc-getAR) \
		RANLIB=$(tc-getRANLIB)
}

src_install() {
	LC_ALL=C emake -j1 \
		DESTDIR="${D}" \
		STRIP=: \
		nmapdatadir=/usr/share/nmap \
		install

	dodoc CHANGELOG HACKING docs/README docs/*.txt
}


# vim: filetype=ebuild
