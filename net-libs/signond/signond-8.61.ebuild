# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
inherit qmake-utils

DESCRIPTION="SignOn Daemon (Qt)"
HOMEPAGE="https://gitlab.com/accounts-sso/signond"
SRC_URI="https://gitlab.com/accounts-sso/signond/-/archive/VERSION_8.61/signond-VERSION_8.61.tar.bz2 -> signond-8.61.tar.bz2"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="*"
RDEPEND="dev-qt/qtbase:6[gui,sql]
	net-libs/libproxy
	
"
S="${WORKDIR}/signond-VERSION_8.61"
src_prepare() {
	  default
	   # Qt6
	  sed -i 's/^class QStringList;/#include <QStringList>/' \
	      lib/plugins/SignOn/authpluginif.h || die
	   sed -i 's/Q_EXTERN_C/extern "C"/' \
	      lib/plugins/SignOn/authpluginif.h || die
	   sed -i 's/QString::SkipEmptyParts/Qt::SkipEmptyParts/g' \
	      src/signond/signonidentityinfo.cpp || die
	   sed -i '/m_plugin->mechanisms()\.toSet()\./{N;s/m_plugin->mechanisms()\.toSet()\.\n.*intersect(wantedMechanisms\.toSet())\.toList()/QSet<QString>(m_plugin->mechanisms().begin(), m_plugin->mechanisms().end()).intersect(QSet<QString>(wantedMechanisms.begin(), wantedMechanisms.end())).values()/}' \
	      src/signond/signonsessioncore.cpp || die
	  # Add QSet include if missing
	  grep -q '#include <QSet>' src/signond/signonsessioncore.cpp || \
	      sed -i '1i #include <QSet>' src/signond/signonsessioncore.cpp || die
	   sed -i 's/uiRequest\.unite(params)/uiRequest.insert(params)/' \
	      src/signond/signonidentity.cpp || die
	  sed -i 's/return map\.unite(map2)/map.insert(map2);\n    return map/' \
	      src/signond/signonsessioncoretools.cpp || die
	   sed -i 's/m_process->pid()/m_process->processId()/g' \
	      src/signond/pluginproxy.cpp || die
	   sed -i 's/SUBDIRS   = lib src server tests/SUBDIRS   = lib src server/' \
	      signon.pro || die
	   sed -i \
	      -e 's/LIBSIGNON = libsignon-qt5/LIBSIGNON = libsignon-qt6/' \
	      -e 's/CMAKE_BASENAME = SignOnQt5/CMAKE_BASENAME = SignOnQt6/' \
	      common-project-config.pri || die
	   sed -i 's/signon-qt5/signon-qt6/g' \
	      lib/SignOn/libsignon-qt.pri || die
	   mv lib/SignOn/SignOnQt5Config.cmake.in lib/SignOn/SignOnQt6Config.cmake.in || die
	  mv lib/SignOn/SignOnQt5ConfigVersion.cmake.in lib/SignOn/SignOnQt6ConfigVersion.cmake.in || die
	   mv lib/SignOn/libsignon-qt5.pc.in lib/SignOn/libsignon-qt6.pc.in || die
	  sed -i \
	      -e 's/libsignon-qt5/libsignon-qt6/g' \
	      -e 's/Qt5 bindings/Qt6 bindings/' \
	      -e 's/Requires: Qt5Core/Requires: Qt6Core/' \
	      lib/SignOn/libsignon-qt6.pc.in || die
	   sed -i 's/libsignon-qt5\.pc/libsignon-qt6.pc/g' \
	      lib/SignOn/libsignon-qt.pri || die
}
_get_qt6_qmake() {
	  echo "${EPREFIX}/usr/$(get_libdir)/qt6/bin/qmake"
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
