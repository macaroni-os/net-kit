# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
inherit meson vala

DESCRIPTION="libportal - Flatpak portal library"
HOMEPAGE="https://libportal.org"
SRC_URI="https://api.github.com/repos/flatpak/libportal/tarball/0.10.0 -> libportal-0.10.0-c230240.tar.gz"
LICENSE="LGPL-3.0"
SLOT="0"
KEYWORDS="*"
IUSE="gtk gtk-doc +introspection qt5 qt6 +vala wayland X"
REQUIRED_USE="gtk-doc? ( introspection )
vala? ( introspection )
"
BDEPEND="virtual/pkgconfig
	gtk-doc? ( dev-util/gi-docgen )
	vala? ( $(vala_depend) )
	
"
RDEPEND="dev-libs/glib:2
	introspection? ( dev-libs/gobject-introspection:= )
	gtk? (
	  x11-libs/gtk+:3[introspection?,wayland?,X?]
	  x11-libs/gtk:4[introspection?,wayland?,X?]
	)
	qt5? ( dev-qt/qtcore:5 )
	qt6? ( dev-qt/qtbase:6[gui] )
	
"
DEPEND="${RDEPEND}
"

post_src_unpack() {
	mv flatpak-libportal-* ${S}
}


src_prepare() {
	default
	vala_src_prepare
	# Fix qt6 compilation
	sed -i \
	-e 's|^#include <private/qgenericunixservices_p.h>|#include <private/qdesktopunixservices_p.h>|g' \
	-e 's|QGenericUnixServices|QDesktopUnixServices|g' \
	libportal/portal-qt6.cpp
}
src_configure() {
	local emesonargs=(
	  $(meson_feature gtk backend-gtk3)
	  $(meson_feature gtk backend-gtk4)
	  $(meson_feature qt5 backend-qt5)
	  $(meson_feature qt6 backend-qt6)
	  $(meson_use introspection)
	  $(meson_use vala vapi)
	  $(meson_use gtk-doc docs)
	  -Dtests=false
	  -Dportal-tests=false
	)
	meson_src_configure
}
src_install() {
	meson_src_install
	if use gtk-doc; then
	  mkdir -p "${ED}"/usr/share/gtk-doc/html/ || die
	  mv "${ED}"/usr/share/doc/${PN}-1 "${ED}"/usr/share/gtk-doc/html/ || die
	fi
}



# vim: filetype=ebuild
