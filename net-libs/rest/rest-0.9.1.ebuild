# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
inherit meson vala

DESCRIPTION="Helper library for RESTful services"
HOMEPAGE="https://wiki.gnome.org/Projects/Librest"
SRC_URI="https://download.gnome.org/sources/rest/0.9/rest-0.9.1.tar.xz -> rest-0.9.1.tar.xz"
LICENSE="LGPL-2.1"
SLOT="1.0"
KEYWORDS="*"
PATCHES=(
	"${FILESDIR}/0001-rest_proxy_call_sync-bail-out-if-no-payload.patch"
	"${FILESDIR}/0002-Handle-some-potential-problems-in-parsing-oauth2-acc.patch"
)
IUSE="gtk-doc +introspection vala"
REQUIRED_USE="gtk-doc? ( introspection )
vala? ( introspection )
"
BDEPEND="gtk-doc? ( dev-util/gi-docgen )
	vala? ( $(vala_depend) )
	
"
RDEPEND="dev-libs/glib:2
	net-libs/libsoup:3
	dev-libs/json-glib:0[introspection?]
	dev-libs/libxml2:2=
	app-misc/ca-certificates
	introspection? ( dev-libs/gobject-introspection:= )
	!net-libs/rest:0.7
	
"
DEPEND="${RDEPEND}
"
src_prepare() {
	default
	vala_src_prepare
	sed -i -e '/flickr/d' -e '/lastfm/d' tests/meson.build
}
src_configure() {
	local emesonargs=(
	  -Dca_certificates=true
	  -Dca_certificates_path="${EPREFIX}"/etc/ssl/certs/ca-certificates.crt
	  $(meson_use introspection)
	  $(meson_use vala vapi)
	  -Dexamples=false
	  $(meson_use gtk-doc gtk_doc)
	  -Dsoup2=false
	  -Dtests=false
	)
	meson_src_configure
}
src_install() {
	meson_src_install
}


# vim: filetype=ebuild
