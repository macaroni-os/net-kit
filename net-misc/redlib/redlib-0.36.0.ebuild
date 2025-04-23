# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION=" Private front-end for Reddit "
HOMEPAGE="https://github.com/redlib-org/redlib"
SRC_URI="https://github.com/redlib-org/redlib/tarball/15147cea8e42f6569a11603d661d71122f6a02dc -> redlib-0.36.0-15147ce.tar.gz
https://distfiles.macaronios.org/bc/98/51/bc9851e7de39a7e69a5da352a6b62c0a357d5be9daf1d2ff39f7a8d48dcee35a3bb61900fa6d94641af158460e567a5fcc3b9c6d3d3524e9939f96f3cf04a56b -> redlib-0.36.0-funtoo-crates-bundle-f21431ffcb2ea2828869cfa4f5621e477edec9c2a417aaba5f202ccc04f0c7ef0b37bd8bb85ba84dfb12652687eece33609d43b0159774e9ec5277b49557a737.tar.gz"

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