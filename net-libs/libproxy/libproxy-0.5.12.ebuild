# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
inherit meson vala

DESCRIPTION=""
HOMEPAGE="http://libproxy.github.io/libproxy"
SRC_URI="https://api.github.com/repos/libproxy/libproxy/tarball/refs/tags/0.5.12 -> libproxy-0.5.12-99da019.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="*"
IUSE="duktape gnome gtk-doc +introspection vala"
REQUIRED_USE="gtk-doc? ( introspection )
vala? ( introspection )
"
BDEPEND="virtual/pkgconfig
	gtk-doc? ( dev-util/gi-docgen )
	vala? ( $(vala_depend) )
	
"
RDEPEND="dev-libs/glib:2
	gnome? ( gnome-base/gsettings-desktop-schemas )
	duktape? (
	  dev-lang/duktape:=
	  net-misc/curl
	)
	introspection? ( dev-libs/gobject-introspection:= )
	
"
DEPEND="${RDEPEND}
"

post_src_unpack() {
	mv libproxy-libproxy-* ${S}
}


src_prepare() {
	default
	use vala && vala_src_prepare
}
src_configure() {
	local emesonargs=(
	    -Dtests=false
	    -Dconfig-env=true
	    -Dconfig-windows=false
	    -Dconfig-sysconfig=true
	    -Dconfig-osx=false
	    -Dconfig-kde=true
	    -Dconfig-xdp=true
	    $(meson_use gtk-doc docs)
	    $(meson_use vala vapi)
	    $(meson_use duktape pacrunner-duktape)
	    $(meson_use gnome config-gnome)
	    $(meson_use duktape curl)
	    $(meson_use introspection)
	)
	meson_src_configure
}
src_install() {
	meson_src_install
	einstalldocs
	if use gtk-doc; then
	  mkdir -p "${ED}"/usr/share/gtk-doc/html/ || die
	  mv "${ED}"/usr/share/doc/${PN}-1.0 "${ED}"/usr/share/gtk-doc/html/ || die
	fi
}



# vim: filetype=ebuild
