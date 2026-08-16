# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
inherit qmake-utils

DESCRIPTION="OAuth2 plugin for Signon daemon"
HOMEPAGE="https://gitlab.com/nicolasfella/signon-plugin-oauth2"
SRC_URI="https://gitlab.com/nicolasfella/signon-plugin-oauth2/-/archive/fab698862466994a8fdc9aa335c87b4f05430ce6/signon-plugin-oauth2-fab698862466994a8fdc9aa335c87b4f05430ce6.tar.bz2 -> signon-oauth2-0.25_p20231015-fab6988.tar.bz2"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="*"
RDEPEND="dev-qt/qtbase:6
	net-libs/signond
	
"
DEPEND="${RDEPEND}
"

post_src_unpack() {
	mv signon-plugin-oauth2-* ${S}
}


src_prepare() {
	default
	sed -i "s|@LIBDIR@|$(get_libdir)|g" src/signon-oauth2plugin.pc || die
	sed -i -e \
	  "s|TEMPLATE|INCLUDEPATH += /usr/include/signon-qt6 /usr/include/signon-qt6/SignOn\nTEMPLATE|g" \
	   signon-oauth2.pro
}
src_configure() {
	local mycmakeargs=( LIBDIR=/usr/$(get_libdir) )
	eqmake6 "${myqmakeargs[@]}"
}
src_install() {
	emake INSTALL_ROOT="${D}" install
}



# vim: filetype=ebuild
