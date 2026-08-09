# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
inherit libtool

DESCRIPTION="library for developing printing features, split out of cups-filters"
HOMEPAGE="https://github.com/OpenPrinting/libcupsfilters"
SRC_URI="https://github.com/OpenPrinting/libcupsfilters/releases/download/2.2.0/libcupsfilters-2.2.0.tar.xz -> libcupsfilters-2.2.0.tar.xz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="dbus exif jpeg +poppler +postscript png tiff"
BDEPEND=">=sys-devel/gettext-0.18.3
	virtual/pkgconfig
	
"
RDEPEND=">=app-text/qpdf-8.3.0:=
	media-libs/fontconfig
	media-libs/lcms:2
	>=net-print/cups-2
	!<net-print/cups-filters-2.0.0
	exif? ( media-libs/libexif )
	dbus? ( sys-apps/dbus )
	jpeg? ( media-libs/libjpeg-turbo:= )
	postscript? ( app-text/ghostscript-gpl[cups] )
	poppler? ( >=app-text/poppler-0.32:=[cxx] )
	png? ( media-libs/libpng:= )
	tiff? ( media-libs/tiff:= )
	
"
DEPEND="${RDEPEND}
"
src_prepare() {
	default
	 # respect --as-needed
	elibtoolize
}

src_configure() {
	local myeconfargs=(
	  --enable-imagefilters
	  --localstatedir="${EPREFIX}"/var
	  --with-cups-rundir="${EPREFIX}"/run/cups
	  --disable-mutool
	  $(use_enable exif)
	  $(use_enable dbus)
	  $(use_enable poppler)
	  $(use_enable postscript ghostscript)
	  $(use_with jpeg)
	  $(use_with png)
	  $(use_with tiff)
	)
	 econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}


# vim: filetype=ebuild
