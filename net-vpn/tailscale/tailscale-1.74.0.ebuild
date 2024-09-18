# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module tmpfiles

VERSION_SHORT="1.74.0"
VERSION_LONG="1.74.0-t28e0bab29"

DESCRIPTION="Tailscale vpn client"
HOMEPAGE="https://tailscale.com"
SRC_URI="https://github.com/tailscale/tailscale/tarball/28e0bab29dcadfb98c997c142b64b91c0c341652 -> tailscale-1.74.0-28e0bab.tar.gz
https://distfiles.macaronios.org/69/ab/0d/69ab0d4451bc80a942879ea0c8ef1a0efe3c4bdb0ab1c5d0326d6d9abbc81755683177cf2a18550d6feaae7a4d42f1ab3bf50c1b5613adf78cbb4a2202bb1c29 -> tailscale-1.74.0-funtoo-go-bundle-8a7d9100db16e50d4fb65889493d14faa1d0152fce7ddb5851c4a446d1e561699c891b529f780d2b08ef5899348e4be6e6a6257015a7b92f402056ff7a04dc4b.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"

RDEPEND="net-firewall/iptables"
S="${WORKDIR}/tailscale-tailscale-28e0bab"

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