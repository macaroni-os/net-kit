# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION=" Private front-end for Reddit "
HOMEPAGE="https://github.com/redlib-org/redlib"
SRC_URI="https://github.com/redlib-org/redlib/tarball/d9e768100460dabb8016288ca17f22bdbada3a53 -> redlib-0.35.1-d9e7681.tar.gz
https://distfiles.macaronios.org/e8/bd/b9/e8bdb95040abe2115a92b1f0ea2cfde25a06a9a790535a0950fdbff73635d3d0565b2e89bfb6c7be5bc6672ec94444dd9ceb568968111754b9388c3bcbb53b7b -> redlib-0.35.1-funtoo-crates-bundle-a0220ca28de114ce617047a7c2ece23f8cefdb71eea8d86db203e640113acb6c1fcbbf4cf700d4ac11f8cf342029a9e7f1e15e194a386a25d5b11cd6b0a08431.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="*"

DOCS=( README.md )

QA_FLAGS_IGNORED="/usr/bin/redlib"

src_unpack() {
	cargo_src_unpack
	rm -rf ${S}
	mv ${WORKDIR}/redlib-org-redlib-* ${S} || die
}