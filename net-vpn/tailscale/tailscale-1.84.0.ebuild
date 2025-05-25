# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module tmpfiles

VERSION_SHORT="1.84.0"
VERSION_LONG="1.84.0-t160c11f37"

DESCRIPTION="Tailscale vpn client"
HOMEPAGE="https://tailscale.com"
SRC_URI="https://github.com/tailscale/tailscale/tarball/160c11f37850a7e0a50f5efec48cacc333e69a00 -> tailscale-1.84.0-160c11f.tar.gz
https://distfiles.macaronios.org/99/c4/97/99c497971a05de6fe2cd543298e89aeaf41ff2d111879707513dabb4fbef9cda17f2cc96b3a3e576b197fda4e000caf85346d8d3a6e6da8b5bf4bf882ad847fb -> tailscale-1.84.0-funtoo-go-bundle-19631a433f69bcf534bdeb4ed371c6899a3217a7987ae6b1845181f30ef02f6d71d0496cfc816bc6516a32435453c395563091e34488057a5210bc3134314243.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"

RDEPEND="net-firewall/iptables"
S="${WORKDIR}/tailscale-tailscale-160c11f"

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