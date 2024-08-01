# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION=" Private front-end for Reddit "
HOMEPAGE="https://github.com/redlib-org/redlib"
SRC_URI="https://github.com/redlib-org/redlib/tarball/d9e768100460dabb8016288ca17f22bdbada3a53 -> redlib-0.35.1-d9e7681.tar.gz
https://distfiles.macaronios.org/ba/4b/6e/ba4b6e4d34456375f54e766f68e477dd88a138ee762742a1e44b2d8b905936c6330c41aa476c8b9c997a9dc7d07512b8bcc1c0b4f5be87a4424fb86d5a098014 -> redlib-0.35.1-funtoo-crates-bundle-a0220ca28de114ce617047a7c2ece23f8cefdb71eea8d86db203e640113acb6c1fcbbf4cf700d4ac11f8cf342029a9e7f1e15e194a386a25d5b11cd6b0a08431.tar.gz"

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