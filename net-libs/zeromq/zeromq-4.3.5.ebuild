# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools

DESCRIPTION="ZeroMQ core engine in C++, implements ZMTP/3.1"
HOMEPAGE="http://www.zeromq.org/"
SRC_URI="https://github.com/zeromq/libzmq/tarball/4d9c8f8ccf4f659e8397cad42f8496551f534597 -> libzmq-4.3.5-4d9c8f8.tar.gz"

LICENSE="LGPL-3"
SLOT="0/5"
KEYWORDS="*"
IUSE="doc drafts pgm +sodium static-libs test unwind elibc_Darwin"

RDEPEND="
	!elibc_Darwin? ( unwind? ( sys-libs/libunwind ) )
	sodium? ( dev-libs/libsodium:= )
	pgm? ( =net-libs/openpgm-5.2.122 )"
DEPEND="${RDEPEND}
	!elibc_Darwin? ( sys-apps/util-linux )
	doc? (
		app-text/asciidoc
		app-text/xmlto
	)
	pgm? ( virtual/pkgconfig )"

post_src_unpack() {
	if [ ! -d "${S}" ]; then
		mv zeromq-libzmq-* "${S}" || die
	fi
}

src_prepare() {
	sed \
		-e '/libzmq_werror=/s:yes:no:g' \
		-i configure.ac || die
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--enable-shared
		$(use_enable drafts)
		$(use_enable static-libs static)
		$(use_enable unwind libunwind)
		$(use_with sodium libsodium)
		$(use_with pgm)
		$(use_with doc docs)
	)
	econf "${myeconfargs[@]}"
}

src_test() {
	# Restricting to one job because multiple tests are using the same port.
	# Upstream knows the problem and says it doesn't support parallel test
	# execution, see ${S}/INSTALL.
	emake -j1 check
}

src_install() {
	default
	find "${ED%/}"/usr/lib* -name '*.la' -delete || die
}