# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

go-module_set_globals

DESCRIPTION="CoreDNS is a DNS server that chains plugins"
HOMEPAGE="https://coredns.io/ https://github.com/coredns/coredns"
SRC_URI="https://github.com/coredns/coredns/tarball/6e11ebddfc13bfca683fcbcae72cc4af6de47dd2 -> coredns-1.11.4-6e11ebd.tar.gz
https://distfiles.macaronios.org/61/56/ac/6156ac45e909f93b35d4654bb33c6de2aa109253c10f065f678583f8158c0fc22fc2f1a71159ba0916e29f342a8610f1759c51a0a39b880026b4ab578e877a4f -> coredns-1.11.4-funtoo-go-bundle-7b0dd11379a9e0dd3257d978090051e6412722a2267933d88ce1b00e9e57995099eb0320432e37c97f9ac02a527d7823fbecdff62acbb157babd1627c902ae63.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=">=dev-lang/go-1.21"
S="${WORKDIR}/coredns-coredns-6e11ebd"

src_compile() {
	FORCE_HOST_GO=yes
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