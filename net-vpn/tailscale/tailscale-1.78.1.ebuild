# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module tmpfiles

VERSION_SHORT="1.78.1"
VERSION_LONG="1.78.1-t8903926f7"

DESCRIPTION="Tailscale vpn client"
HOMEPAGE="https://tailscale.com"
SRC_URI="https://github.com/tailscale/tailscale/tarball/8903926f7167f4c4a2e21a6e3c0dae855322f3d6 -> tailscale-1.78.1-8903926.tar.gz
https://distfiles.macaronios.org/44/2e/a7/442ea709c67097b0046c58e80b0c596c8aa3a7dac440aa682bfc7e17215daa77db912594401884bf99aa7be3ef646caafbacee57bddbb3b4725a2dae5f60812f -> tailscale-1.78.1-funtoo-go-bundle-218cc878f24dbd969df388050742abc1367c1b8610f0ab5c956cbd9c46a25c52d3950e1c88c7179d2c27ef73c68969134220e12867c357a308021c824673b9ea.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"

RDEPEND="net-firewall/iptables"
S="${WORKDIR}/tailscale-tailscale-8903926"

# This translates the build command from upstream's build_dist.sh to an
# ebuild equivalent.
build_dist() {
	go build -tags xversion -ldflags "
		-X tailscale.com/version.longStamp=${VERSION_LONG}
		-X tailscale.com/version.shortStamp=${VERSION_SHORT}" "$@"
}

src_compile() {
	build_dist ./cmd/tailscale
	build_dist ./cmd/tailscaled
}

src_install() {
	dosbin tailscaled
	dobin tailscale

	insinto /etc/default
	newins cmd/tailscaled/tailscaled.defaults tailscaled
	keepdir /var/lib/${PN}
	fperms 0750 /var/lib/${PN}

	newtmpfiles "${FILESDIR}/${PN}.tmpfiles" ${PN}.conf

	newinitd "${FILESDIR}/${PN}d.initd" ${PN}
	newconfd "${FILESDIR}/${PN}d.confd" ${PN}
}

pkg_postinst() {
	tmpfiles_process ${PN}.conf
}