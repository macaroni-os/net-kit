# Distributed under the terms of the GNU General Public License v2

EAPI=7
GNOME_ORG_MODULE="NetworkManager-${PN##*-}"

inherit gnome3 user

DESCRIPTION="NetworkManager OpenConnect plugin"
HOMEPAGE="https://wiki.gnome.org/Projects/NetworkManager"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"
IUSE="gnome"
SRC_URI="https://gitlab.gnome.org/GNOME/NetworkManager-openconnect/-/archive/7747070b387ee72c71f88999770925d941e28ab7/NetworkManager-openconnect-7747070b387ee72c71f88999770925d941e28ab7.tar.gz -> networkmanager-openconnect-1.2.6.20200831.tar.gz"
S="$WORKDIR/NetworkManager-openconnect-7747070b387ee72c71f88999770925d941e28ab7"

RDEPEND="
	>=net-misc/networkmanager-1.2:=
	>=dev-libs/glib-2.32:2
	dev-libs/libxml2:2
	>=net-vpn/openconnect-3.02:=
	gnome? (
		>=app-crypt/gcr-3.4:=
		>=app-crypt/libsecret-0.18
		>=x11-libs/gtk+-3.4:3 )
"
DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/intltool
	virtual/pkgconfig
"

src_prepare() {
	gnome3_src_prepare
	./autogen.sh || die
}

src_configure() {
	gnome3_src_configure \
		--disable-more-warnings \
		--disable-static \
		--without-libnm-glib \
		$(use_with gnome gnome) \
		$(use_with gnome authdlg)
}

pkg_postinst() {
	gnome3_pkg_postinst
	enewgroup nm-openconnect
	enewuser nm-openconnect -1 -1 -1 nm-openconnect
}