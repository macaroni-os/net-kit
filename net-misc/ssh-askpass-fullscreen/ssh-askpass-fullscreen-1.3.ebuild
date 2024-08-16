# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools eutils

DESCRIPTION="A small SSH askpass GUI using GTK+2"
HOMEPAGE="https://github.com/atj/ssh-askpass-fullscreen"
SRC_URI="https://github.com/atj/ssh-askpass-fullscreen/tarball/fd59e76b564a4814e7dd43eb363d300c9c6bd588 -> ssh-askpass-fullscreen-1.3-fd59e76.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"
IUSE=""

S="${WORKDIR}/atj-ssh-askpass-fullscreen-fd59e76"

RDEPEND=">=x11-libs/gtk+-2.10.0:2
	x11-libs/libX11"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	# automake-1.13 fix, bug #468764
	sed -i -e 's|AM_CONFIG_HEADER|AC_CONFIG_HEADERS|g' configure.ac || die

	default
	eautoreconf
}

src_install() {
	default
	# Automatically display the passphrase dialog - see bug #437764
	echo "SSH_ASKPASS='${EPREFIX}/usr/bin/ssh-askpass-fullscreen'" >> "${T}/99ssh_askpass" \
		|| die "envd file creation failed"
	doenvd "${T}"/99ssh_askpass || die "doenvd failed"
}