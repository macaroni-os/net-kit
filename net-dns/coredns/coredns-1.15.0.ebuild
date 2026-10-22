# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
inherit go-module systemd

DESCRIPTION="CoreDNS is a DNS server that chains plugins"
HOMEPAGE="https://coredns.io"
SRC_URI="
https://api.github.com/repos/coredns/coredns/tarball/v1.15.0 -> coredns-1.15.0-a6fde3f.tar.gz
mirror://macaroni/coredns-1.15.0-mark-go-bundle-a6fde3f.tar.xz -> coredns-1.15.0-mark-go-bundle-a6fde3f.tar.xz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="systemd"
BDEPEND="dev-lang/go
	
"

post_src_unpack() {
	mv coredns-coredns-* ${S}
}


src_compile() {
	export GITCOMMIT=a6fde3fe339c6ec848447e11cc9796be8c97b4e0
	unset LDFLAGS
	echo "$(go env GOVERSION | sed 's/go//g')" > .go-version
	emake
}
src_install() {
	dobin ${PN}
	insinto /etc/"${PN}"
	doins "${FILESDIR}"/Corefile
	dodoc README.md
	doman man/*
	if use systemd ; then
	  systemd_dounit "${FILESDIR}"/coredns.service
	else
	  newinitd "${FILESDIR}"/"${PN}".initd ${PN}
	fi
	newconfd "${FILESDIR}"/"${PN}".confd ${PN}
	keepdir /var/log/"${PN}"
}



# vim: filetype=ebuild
