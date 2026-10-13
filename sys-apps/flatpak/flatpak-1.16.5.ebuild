# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
PYTHON_COMPAT=( python3+ )
inherit meson python-any-r1 user

DESCRIPTION="Linux application sandboxing and distribution framework"
HOMEPAGE="https://flatpak.org/"
SRC_URI="https://api.github.com/repos/flatpak/flatpak/tarball/1.16.5 -> flatpak-1.16.5-4b48ee8.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="*"
IUSE="introspection policykit seccomp X gnome kde"
BDEPEND="sys-devel/gettext
	virtual/pkgconfig
	dev-util/gdbus-codegen
	sys-devel/bison
	introspection? ( dev-libs/gobject-introspection )
	$(python_gen_any_dep '
	  dev-python/pyparsing[${PYTHON_USEDEP}]
	')
	net-misc/socat
	
"
RDEPEND="sys-fs/libostree
	net-libs/libsoup
	gnome-base/dconf
	dev-libs/appstream
	dev-libs/appstream-glib
	x11-libs/gdk-pixbuf:2
	dev-libs/glib
	dev-libs/libxml2
	sys-apps/dbus
	dev-libs/json-glib
	x11-apps/xauth
	app-arch/libarchive
	app-crypt/gpgme
	sys-fs/fuse
	>=sys-apps/bubblewrap-0.10.0
	dev-util/xdg-dbus-proxy
	policykit? ( sys-auth/polkit )
	seccomp? ( sys-libs/libseccomp )
	
"
DEPEND="${RDEPEND}
"
PDEPEND="gnome? (
	  sys-apps/xdg-desktop-portal
	  sys-apps/xdg-desktop-portal-gtk
	)
	kde? (
	  sys-apps/xdg-desktop-portal
	  sys-apps/xdg-desktop-portal-kde
	)
	
"

post_src_unpack() {
	mv flatpak-flatpak-* ${S}
}


pkg_setup() {
	enewgroup flatpak
	enewuser flatpak -1 -1 /dev/null flatpak
	python-any-r1_pkg_setup
}
src_configure() {
	local emesonargs=(
	  --localstatedir="${EPREFIX}"/var
	  -Ddbus_config_dir=/usr/share/dbus-1/system.d
	  -Dsystem_bubblewrap=bwrap
	  -Dsystem_dbus_proxy=xdg-dbus-proxy
	  -Dtmpfilesdir=/usr/lib/tmpfiles.d
	  # Disable doc generation
	  -Dgtkdoc=disabled
	  -Ddocbook_docs=disabled
	  # Disable systemd support
	  -Dsystemd=disabled
	  $(meson_use gnome gdm_env_file)
	  $(meson_use policykit tests)
	  $(meson_feature policykit system_helper)
	  $(meson_feature introspection gir)
	  $(meson_feature X xauth)
	  $(meson_feature seccomp seccomp)
	)
	 meson_src_configure
}



# vim: filetype=ebuild
