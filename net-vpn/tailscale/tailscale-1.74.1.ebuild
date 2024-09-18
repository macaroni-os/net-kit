# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module tmpfiles

VERSION_SHORT="1.74.1"
VERSION_LONG="1.74.1-tccd6bf2f4"

DESCRIPTION="Tailscale vpn client"
HOMEPAGE="https://tailscale.com"
SRC_URI="https://github.com/tailscale/tailscale/tarball/ccd6bf2f4ee6421c23789b64e6e63c2ccbe87e08 -> tailscale-1.74.1-ccd6bf2.tar.gz
https://distfiles.macaronios.org/80/fe/d0/80fed04e73e48aae4e9b2fc0f95f0b2cd23e81e102614e8aa21040d444107c2248d0af760a6371424cdff6ea05aab2b7caab0dd6223672823bedce51b110fb53 -> tailscale-1.74.1-funtoo-go-bundle-8a7d9100db16e50d4fb65889493d14faa1d0152fce7ddb5851c4a446d1e561699c891b529f780d2b08ef5899348e4be6e6a6257015a7b92f402056ff7a04dc4b.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"

RDEPEND="net-firewall/iptables"
S="${WORKDIR}/tailscale-tailscale-ccd6bf2"

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