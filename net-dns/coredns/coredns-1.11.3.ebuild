# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

go-module_set_globals

DESCRIPTION="CoreDNS is a DNS server that chains plugins"
HOMEPAGE="https://coredns.io/ https://github.com/coredns/coredns"
SRC_URI="https://github.com/coredns/coredns/tarball/a7ed346585e30b99317d36e4d007b7b19a228ea5 -> coredns-1.11.3-a7ed346.tar.gz
https://distfiles.macaronios.org/ef/10/ec/ef10ecbdfad1ca329b51659a154e1849532c3e64a1c4b3027fe6491f45d186242363bfd6e69d22c3bf0506aaa44eb0513ab06fe13c1b094fd32b2ce03d91450c -> coredns-1.11.3-funtoo-go-bundle-c176a278c92fedd12ca468562681e8e4067232fccde751ea62b548f59af5b39799140233e9dc7c15c95f3848eb8ae66b566dc002e2aeef20f6689ec2d9f66000.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=">=dev-lang/go-1.21"
S="${WORKDIR}/coredns-coredns-a7ed346"

src_compile() {
	FORCE_HOST_GO=yes
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