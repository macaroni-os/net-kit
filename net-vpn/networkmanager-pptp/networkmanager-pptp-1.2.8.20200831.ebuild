# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME_ORG_MODULE="NetworkManager-${PN##*-}"

inherit gnome3

DESCRIPTION="NetworkManager PPTP VPN plugin"
HOMEPAGE="https://wiki.gnome.org/Projects/NetworkManager/VPN"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"
IUSE="gnome"
SRC_URI="https://gitlab.gnome.org/GNOME/NetworkManager-pptp/-/archive/558fb963bc0fb6a508a147f184342ec8676ef1d8/NetworkManager-pptp-558fb963bc0fb6a508a147f184342ec8676ef1d8.tar.gz -> networkmanager-pptp-1.2.8.20200831.tar.gz"
S="$WORKDIR/NetworkManager-pptp-558fb963bc0fb6a508a147f184342ec8676ef1d8"
RDEPEND="
	>=net-misc/networkmanager-1.26.0:=
	>=dev-libs/dbus-glib-0.74
	>=dev-libs/glib-2.32:2
	net-dialup/ppp:=
	net-dialup/pptpclient
	gnome? (
		>=net-libs/libnma-1.2.0
		>=app-crypt/libsecret-0.18
		>=x11-libs/gtk+-3.4:3
	)
"
# libxml2 required for glib-compile-resources
DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-libs/libxml2:2
	dev-util/gdbus-codegen
	dev-util/intltool
	virtual/pkgconfig
"

src_prepare() {
	gnome3_src_prepare
	./autogen.sh || die
}

src_configure() {
	local myconf
	# Same hack as net-dialup/pptpd to get proper plugin dir for ppp, bug #519986
	local PPPD_VER=`best_version net-dialup/ppp`
	PPPD_VER=${PPPD_VER#*/*-} #reduce it to ${PV}-${PR}
	PPPD_VER=${PPPD_VER%%[_-]*} # main version without beta/pre/patch/revision
	myconf="${myconf} --with-pppd-plugin-dir=/usr/$(get_libdir)/pppd/${PPPD_VER}"

	gnome3_src_configure \
		--disable-more-warnings \
		--disable-static \
		--with-dist-version=Funtoo \
		--without-nm-glib \
		$(use_with gnome gnome) \
		${myconf}
}