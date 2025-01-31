# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module tmpfiles

VERSION_SHORT="1.80.0"
VERSION_LONG="1.80.0-t4f4686503"

DESCRIPTION="Tailscale vpn client"
HOMEPAGE="https://tailscale.com"
SRC_URI="https://github.com/tailscale/tailscale/tarball/4f4686503ae930740854e71efef4baa4ac815844 -> tailscale-1.80.0-4f46865.tar.gz
https://distfiles.macaronios.org/75/e4/54/75e454a06897743f6bf77a2581b2fca18e669d16b4257684ebf036614118b955c4b4a7bf3349d68871c53ebc1ca78520058fd35e64f2818979902928d9c436da -> tailscale-1.80.0-funtoo-go-bundle-cb95adae61a133280408a1b9f3db5e9b4272e02e73973fb5976513c8e97c52ceb0079bfe8ae968476e8a7c91c1aa4a4d0228ee6e0b4f03e23bbc5445506c0f9f.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"

RDEPEND="net-firewall/iptables"
S="${WORKDIR}/tailscale-tailscale-4f46865"

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