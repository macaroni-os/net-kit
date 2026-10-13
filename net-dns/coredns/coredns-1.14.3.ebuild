# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
inherit go-module

DESCRIPTION="CoreDNS is a DNS server that chains plugins"
HOMEPAGE="https://coredns.io"
SRC_URI="
https://api.github.com/repos/coredns/coredns/tarball/v1.14.3 -> coredns-1.14.3-17fceec.tar.gz
mirror://macaroni/coredns-1.14.3-mark-go-bundle-17fceec.tar.xz -> coredns-1.14.3-mark-go-bundle-17fceec.tar.xz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
BDEPEND="dev-lang/go
	
"

post_src_unpack() {
	mv coredns-coredns-* ${S}
}


src_compile() {
	export GITCOMMIT=17fceec6d93fd1dde5ba6888c363f131ff6d647f
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
