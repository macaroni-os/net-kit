# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 systemd

DESCRIPTION="Tools for configuring Amnezia-WG "
HOMEPAGE="https://github.com/amnezia-vpn/amneziawg-tools"
SRC_URI="https://github.com/amnezia-vpn/amneziawg-tools/tarball/c0b400c6dfc046f5cae8f3051b14cb61686fcf55 -> amneziawg-tools-1.0.20241018-c0b400c.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

post_src_unpack() {
	mv ${WORKDIR}/amnezia-vpn-amneziawg-tools-* ${S} || die
}

src_compile() {
	emake RUNSTATEDIR="${EPREFIX}/run" -C src CC="$(tc-getCC)" LD="$(tc-getLD)"
}

src_install() {
	insinto /etc/netif.d
	doins ${FILESDIR}/amneziawg
	dodoc README.md
	dodoc -r contrib
	emake \
		WITH_BASHCOMPLETION=yes \
		WITH_SYSTEMDUNITS=yes \
		WITH_WGQUICK=yes \
		DESTDIR="${D}" \
		BASHCOMPDIR="$(get_bashcompdir)" \
		SYSTEMDUNITDIR="$(systemd_get_systemunitdir)" \
		PREFIX="${EPREFIX}/usr" \
		-C src install
}