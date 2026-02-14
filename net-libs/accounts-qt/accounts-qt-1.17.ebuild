# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
inherit qmake-utils

DESCRIPTION="Qt6 bindings for libaccounts-glib"
HOMEPAGE="https://gitlab.com/accounts-sso/libaccounts-qt"
SRC_URI="https://gitlab.com/accounts-sso/libaccounts-qt/-/archive/VERSION_1.17/accounts-qt-VERSION_1.17.tar.bz2 -> accounts-qt-1.17.tar.bz2"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="*"
PATCHES=(
	"${FILESDIR}/accounts-qt-1.16-libdir.patch"
)
IUSE="doc"
BDEPEND="doc? (
	    app-doc/doxygen[dot]
	    dev-qt/qttools:6[assistant]
	)
	
"
RDEPEND=">=net-libs/libaccounts-glib-1.23
	dev-libs/glib:2
	dev-qt/qtbase:6
	
"
S="${WORKDIR}/libaccounts-qt-VERSION_1.17"
_get_qt6_qmake() {
	  echo "${EPREFIX}/usr/$(get_libdir)/qt6/bin/qmake"
}
src_prepare() {
	  default
	   sed -e "s|share/doc/\$\${PROJECT_NAME}|share/doc/${PF}|" \
	      -i doc/doc.pri || die
	  sed -e "/QHG_LOCATION/s|qhelpgenerator|${EPREFIX}/usr/$(get_libdir)/qt6/libexec/&|" \
	      -i doc/doxy.conf || die
	  if ! use doc; then
	      sed -e "/include( doc\/doc.pri )/d" -i ${PN}.pro || die
	  fi
	  sed -e '/^SUBDIRS/s/tests//' \
	      -i accounts-qt.pro || die "couldn't disable tests"
}
src_configure() {
	  $(_get_qt6_qmake) \
	      -makefile \
	      QMAKE_AR="$(tc-getAR) cqs" \
	      QMAKE_CC="$(tc-getCC)" \
	      QMAKE_LINK_C="$(tc-getCC)" \
	      QMAKE_LINK_C_SHLIB="$(tc-getCC)" \
	      QMAKE_CXX="$(tc-getCXX)" \
	      QMAKE_LINK="$(tc-getCXX)" \
	      QMAKE_LINK_SHLIB="$(tc-getCXX)" \
	      QMAKE_OBJCOPY="$(tc-getOBJCOPY)" \
	      QMAKE_RANLIB= \
	      QMAKE_STRIP= \
	      QMAKE_CFLAGS="${CFLAGS}" \
	      QMAKE_CFLAGS_RELEASE= \
	      QMAKE_CFLAGS_DEBUG= \
	      QMAKE_CXXFLAGS="${CXXFLAGS}" \
	      QMAKE_CXXFLAGS_RELEASE= \
	      QMAKE_CXXFLAGS_DEBUG= \
	      QMAKE_LFLAGS="${LDFLAGS}" \
	      QMAKE_LFLAGS_RELEASE= \
	      QMAKE_LFLAGS_DEBUG= \
	      PREFIX="${EPREFIX}"/usr \
	      LIBDIR=$(get_libdir) \
	      || die "qmake failed"
}
src_install() {
	  emake INSTALL_ROOT="${D}" install
}


# vim: filetype=ebuild
