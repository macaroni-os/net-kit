# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
inherit qmake-utils

DESCRIPTION="Online accounts signon UI"
HOMEPAGE="https://gitlab.com/accounts-sso/signon-ui"
SRC_URI="https://gitlab.com/accounts-sso/signon-ui/-/archive/eef943f0edf3beee8ecb85d4a9dae3656002fc24/signon-ui-eef943f0edf3beee8ecb85d4a9dae3656002fc24.tar.bz2 -> signon-ui-0.17_p20231016-eef943f.tar.bz2"
LICENSE="GPL-2 GPL-3"
SLOT="0"
KEYWORDS="*"
PATCHES=(
	"${FILESDIR}/signon-ui-0.17_p20231016-webengine-cachedir-path.patch"
)
RDEPEND="dev-libs/glib:2
	dev-qt/qtbase:6
	dev-qt/qtwebchannel:6
	dev-qt/qtdeclarative:6
	dev-qt/qtwebengine:6
	net-libs/libproxy
	net-libs/signond
	x11-libs/libnotify
	
"
DEPEND="${RDEPEND}
"

post_src_unpack() {
	mv signon-ui-* ${S}
}


src_configure() {
	eqmake6 PREFIX=/usr
}
src_compile() {
	emake -j1
}
src_install() {
	emake INSTALL_ROOT="${D}" -j1 install
}



# vim: filetype=ebuild
