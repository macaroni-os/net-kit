# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module tmpfiles

VERSION_SHORT="1.80.2"
VERSION_LONG="1.80.2-t62b8bf6a0"

DESCRIPTION="Tailscale vpn client"
HOMEPAGE="https://tailscale.com"
SRC_URI="https://github.com/tailscale/tailscale/tarball/62b8bf6a082c4bea1b9e6ee1962c81c6ee5263d3 -> tailscale-1.80.2-62b8bf6.tar.gz
https://distfiles.macaronios.org/c0/1a/25/c01a25943f98c338f7e2c482f96e7446190bbaee7bbf5a3caff100af17570220965336a631b864b7cd3f8a00e89dfd0673e5a641056a3929c9f69396cca616cf -> tailscale-1.80.2-funtoo-go-bundle-8385c1170bf5d5ffb4cab67a4f9d6f57ae9986877e5537c27579837f18b584026a8f14b8af01427293902741fe82110076904630cb58a6653d3c9b6313a181f5.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"

RDEPEND="net-firewall/iptables"
S="${WORKDIR}/tailscale-tailscale-62b8bf6"

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