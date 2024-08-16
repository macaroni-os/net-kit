# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="0mq 'highlevel' C++ bindings"
HOMEPAGE="https://github.com/zeromq/zmqpp"
SRC_URI="https://github.com/zeromq/zmqpp/tarball/f8ff127683dc555aa004c0e6e2b18d2354a375be -> zmqpp-4.2.0-f8ff127.tar.gz"
KEYWORDS="*"

LICENSE="MPL-2.0"
SLOT="0"
IUSE="static-libs"

DEPEND="net-libs/zeromq[static-libs?]"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-multilib-strict.patch" )

src_prepare() {
	# Use multilib dir names
	sed -i \
		-e "s:\(LIBRARY DESTINATION \)lib:\1 \$(CMAKE_INSTALL_LIBDIR):" \
		-e "s:\(ARCHIVE DESTINATION \)lib:\1 \$(CMAKE_INSTALL_LIBDIR):" \
	CMakeLists.txt
}

src_configure() {
	local mycmakeargs=(
		-DIS_TRAVIS_CI_BUILD=OFF
		-DZMQPP_BUILD_SHARED=ON
		-DZMQPP_BUILD_STATIC=$(usex static-libs)
	)

	cmake_src_configure
}