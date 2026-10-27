# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
PYTHON_COMPAT=( python3+ )
inherit meson python-single-r1

DESCRIPTION="A set of services and D-Bus APIs to simplify access to UPnP/DLNA media devices"
HOMEPAGE="https://gitlab.gnome.org/World/dLeyna"
SRC_URI="https://gitlab.gnome.org/World/dLeyna/-/archive/v0.8.3/dLeyna-v0.8.3.tar.bz2 -> dleyna-0.8.3-69e5fd6.tar.bz2"
LICENSE="LGPL-2.1"
SLOT="1.0"
KEYWORDS="*"
PATCHES=(
	"${FILESDIR}/dleyna-0.8.3-gupnp-av-autoptr-cleanup.patch"
)
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
BDEPEND="dev-python/docutils
	virtual/pkgconfig
	
"
RDEPEND=">=dev-libs/glib-2.28:2
	>=net-libs/gssdp-1.6.0:1.6
	>=net-libs/gupnp-1.6.0:1.6
	>=net-libs/gupnp-av-0.12.9:0=
	>=media-libs/gupnp-dlna-0.9.4:2.0
	>=net-libs/libsoup-3.0:3
	dev-libs/libxml2:2
	${PYTHON_DEPS}
	!net-libs/dleyna-connector-dbus
	!net-libs/dleyna-core
	!net-libs/dleyna-renderer
	!net-misc/dleyna-server
	
"
DEPEND="${RDEPEND}
"
S="${WORKDIR}/dLeyna-v0.8.3"
src_configure() {
	local emesonargs=(
		-Ddbus_service_dir="${EPREFIX}/usr/share/dbus-1/services"
		-Dman_pages=true
		-Ddocs=false
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	python_optimize
}


# vim: filetype=ebuild
