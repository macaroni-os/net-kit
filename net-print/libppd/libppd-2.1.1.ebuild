# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
inherit libtool

DESCRIPTION="Legacy library for PPD files, split out of cups-filters"
HOMEPAGE="https://github.com/OpenPrinting/libppd"
SRC_URI="https://github.com/OpenPrinting/libppd/releases/download/2.1.1/libppd-2.1.1.tar.xz -> libppd-2.1.1.tar.xz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="+postscript +poppler"
REQUIRED_USE="|| ( postscript poppler )"
BDEPEND=">=sys-devel/gettext-0.18.3
	virtual/pkgconfig
	
"
RDEPEND=">=net-print/cups-2
	net-print/libcupsfilters
	!<net-print/cups-filters-2.0.0
	sys-libs/zlib
	postscript? ( >=app-text/ghostscript-gpl-9.09[cups] )
	poppler? ( >=app-text/poppler-0.32[utils] )
	
"
DEPEND="${RDEPEND}
"
src_prepare() {
	default
	elibtoolize
}

src_configure() {
	local myeconfargs=(
	  --localstatedir="${EPREFIX}"/var
	  --with-cups-rundir="${EPREFIX}"/run/cups
	  # This does build time checks for (preferred) tool interfaces.
	  $(use_enable postscript ghostscript)
	  $(use_enable poppler pdftops)
	  # These fallbacks are just probed for the path. Always enable them.
	  --with-mutool-path="${EPREFIX}"/usr/bin/mutool
	  --with-pdftocairo-path="${EPREFIX}"/usr/bin/pdftocairo
	  # unpackaged
	  --disable-acroread
	)
	 econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}


# vim: filetype=ebuild
