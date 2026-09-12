# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
inherit go-module

DESCRIPTION="CoreDNS is a DNS server that chains plugins"
HOMEPAGE="https://coredns.io"
SRC_URI="
https://api.github.com/repos/coredns/coredns/tarball/v1.14.6 -> coredns-1.14.6-424d125.tar.gz
mirror://macaroni/coredns-1.14.6-mark-go-bundle-424d125.tar.xz -> coredns-1.14.6-mark-go-bundle-424d125.tar.xz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
BDEPEND="dev-lang/go
	
"

post_src_unpack() {
	mv coredns-coredns-* ${S}
}


src_compile() {
	export GITCOMMIT=424d125775cd70fa90dfc80bf0e52cc9a9aeb574
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
	newinitd "${FILESDIR}"/"${PN}".initd ${PN}
	newconfd "${FILESDIR}"/"${PN}".confd ${PN}
	keepdir /var/log/"${PN}"
}



# vim: filetype=ebuild
