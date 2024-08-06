# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module tmpfiles

VERSION_SHORT="1.70.0"
VERSION_LONG="1.70.0-t0e0a21241"

DESCRIPTION="Tailscale vpn client"
HOMEPAGE="https://tailscale.com"
SRC_URI="https://github.com/tailscale/tailscale/tarball/0e0a212418fbf8243cb3f06634367b61e81ea9db -> tailscale-1.70.0-0e0a212.tar.gz
https://distfiles.macaronios.org/4e/32/8f/4e328f15f285fe0cdeda4b62862f2dd1e2058b79174c178e294e14b8ab60e95987830eade46d7bad9fef85066d099c1d4439e27d10e819ec1cae022880b566b1 -> tailscale-1.70.0-funtoo-go-bundle-b1cca7be6b3a1cab1798584fe6fca8a57747dfb3ff8d6b9bfcf2fd6314565a7b96b8748ceebe0f0777dfc1d7462dfb06ebe2464099d188e814709ba365fc65dd.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"

RDEPEND="net-firewall/iptables"
S="${WORKDIR}/tailscale-tailscale-0e0a212"

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