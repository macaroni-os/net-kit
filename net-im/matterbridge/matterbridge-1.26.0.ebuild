# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

go-module_set_globals

DESCRIPTION="Bridges between a growing number of protocols"
HOMEPAGE="https://github.com/42wim/matterbridge"
SRC_URI="https://api.github.com/repos/42wim/matterbridge/tarball/v1.26.0 -> matterbridge-1.26.0.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"

post_src_unpack() {
	mv ${WORKDIR}/42wim-matterbridge-* ${S} || die
}

src_compile() {
	go build -mod=vendor . || die "compile failed"
}

src_install() {
	dobin ${PN}
	dodoc ${PN}.toml.sample
	dodoc ${PN}.toml.simple
}