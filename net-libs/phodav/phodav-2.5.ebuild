# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome.org meson systemd udev

DESCRIPTION="WebDav server implementation using libsoup"
HOMEPAGE="https://wiki.gnome.org/phodav"
LICENSE="LGPL-2.1+"
KEYWORDS="*"

SLOT="2.0"
IUSE="gtk-doc systemd test zeroconf"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/glib:2
	net-libs/libsoup:2.4
	dev-libs/libxml2
	zeroconf? ( net-dns/avahi[dbus] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/asciidoc
	app-text/xmlto
	sys-devel/gettext
	virtual/pkgconfig
	test? ( gnome-base/dconf )
"

PATCHES=(
	"${FILESDIR}"/${PV}-meson-Allow-specifying-systemd-udev-directories.patch
)

src_prepare() {
	default

	if ! use zeroconf ; then
		sed -i -e 's|avahi-daemon.service||' data/spice-webdavd.service || die
	fi
}

src_configure() {
	local emesonargs=(
		$(meson_feature gtk-doc gtk_doc)
		$(meson_feature zeroconf avahi)
		-Dsystemdsystemunitdir="$(systemd_get_systemunitdir)"
		-Dudevrulesdir="$(get_udevdir)/rules.d"
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	if ! use systemd ; then
		newinitd "${FILESDIR}/spice-webdavd.initd" spice-webdavd
		udev_dorules "${FILESDIR}/70-spice-webdavd.rules"
	fi
}
