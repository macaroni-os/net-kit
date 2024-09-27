# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Rustcat(rcat) - The modern Port listener and Reverse shell"
HOMEPAGE="https://github.com/robiot/rustcat"
SRC_URI="https://github.com/robiot/rustcat/tarball/c9e20dde398ee3a8655f95c8f6a8e3fbbb6aee60 -> rustcat-3.0.0-c9e20dd.tar.gz
https://distfiles.macaronios.org/2e/d0/c2/2ed0c239f7bf9aeb007e60f99eafe7cc5a713d1a17e844bb12d58da5bd3700ad867498b96729b30747daa389c13d59312010819e0fbd2bf184976c0c291bc9ec -> rustcat-3.0.0-funtoo-crates-bundle-4cf1ff7aaaa7cc5e021c32250da4b64f86de71b5e90ccd655c656f5da6b23e2e842a0e41f5c9b380b36df2ef9184e2c362a68934cf0435c112b905fdfeb34423.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"

DOCS=( README.md )

QA_FLAGS_IGNORED="/usr/bin/rcat"

post_src_unpack() {
	rm -rf "${S}"
	mv "${WORKDIR}"/robiot-rustcat-* "${S}" || die
}