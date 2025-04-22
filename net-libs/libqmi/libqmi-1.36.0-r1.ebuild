# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
inherit meson

DESCRIPTION="Qualcomm MSM (Mobile Station Modem) Interface (QMI) modem protocol library"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/libqmi/ https://gitlab.freedesktop.org/mobile-broadband/libqmi"
SRC_URI="https://api.github.com/repos/linux-mobile-broadband/libqmi/tarball/refs/tags/1.36.0 -> libqmi-1.36.0.tar.gz"
LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="gtk-doc +mbim +qrtr"
# Commons depends
CDEPEND="dev-libs/glib
	dev-libs/libgudev
	mbim? ( net-libs/libmbim )
	qrtr? ( net-libs/libqrtr-glib )
	
"
BDEPEND="app-shells/bash-completion
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc )
	
"
RDEPEND="${CDEPEND}
	
"
DEPEND="${CDEPEND}
	
"

post_src_unpack() {
	mv linux-mobile-broadband-libqmi-* ${S}
}


src_configure() {
	local emesonargs=(
	  $(meson_use qrtr)
	  $(meson_use mbim mbim_qmux)
	  $(meson_use gtk-doc gtk_doc)
	  $(meson_use qrtr)
	)
	meson_src_configure
}



# vim: filetype=ebuild
