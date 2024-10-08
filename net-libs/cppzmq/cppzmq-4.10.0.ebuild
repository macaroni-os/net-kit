# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Header-only C++ binding for libzmq"
HOMEPAGE="https://github.com/zeromq/cppzmq"
SRC_URI="https://github.com/zeromq/cppzmq/tarball/c94c20743ed7d4aa37835a5c46567ab0790d4acc -> cppzmq-4.10.0-c94c207.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="*"

IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=net-libs/zeromq-4.3.1"
# Tests require cmake modules from catch2 and headers from older version of catch
DEPEND="${RDEPEND}
	test? ( >=dev-cpp/catch-2.5.0
		<dev-cpp/catch-2
	)"

post_src_unpack() {
	if [ ! -d "${S}" ]; then
		mv zeromq-cppzmq* "${S}" || die
	fi
}

src_prepare() {
	# disable static
	sed -i \
			-e "s:\(if (ZeroMQ_FOUND AND \)(\(NOT TARGET libzmq\) OR NOT TARGET libzmq-static)):\1 \2:" \
			-e "s:\(foreach (target\) \(cppzmq cppzmq-static\)):set (cppzmq_targets \2)\n\1 \${cppzmq_targets}):" \
			-e "s:\(install(TARGETS\) cppzmq cppzmq-static:\1 \${cppzmq_targets}:" \
			-e "/target_link_libraries(cppzmq-static INTERFACE libzmq-static)/d" \
		CMakeLists.txt || die
	
	# use the system catch2 library
	if use test; then
		sed -i \
				-e "s:\(include(CTest)\):find_package(Catch2 REQUIRED)\n\1:" \
				-e 's:include(cmake/catch.cmake):include(Catch)\nfind_path(CATCH_INCLUDE_DIR "catch.hpp" HINT /usr/include/catch/):' \
				-e "/include(\${CATCH_MODULE_PATH}/Catch.cmake)/d" \
				-e "s/\(add_dependencies(unit_tests\) catch)/\1 Catch2::Catch2)/" \
				-e "s:\(target_include_directories(unit_tests PUBLIC \${CATCH_\)MODULE_PATH}):\1_INCLUDE_DIR}):" \
			tests/MakeLists.txt || die
	fi

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCPPZMQ_CMAKECONFIG_INSTALL_DIR="/usr/$(get_libdir)/cmake/${PN}/"
		-DCPPZMQ_BUILD_TESTS="$(usex test)"
	)
	if has_version -d '>=net-libs/zeromq-4.3.1[drafts]'; then
		mycmakeargs+=( -DENABLE_DRAFTS=on )
	fi
	cmake_src_configure
}

src_install() {
	cmake_src_install
	einstalldocs
}