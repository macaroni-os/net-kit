# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-mod-r1

DESCRIPTION="AmneziaWG Linux kernel module"
HOMEPAGE="https://github.com/amnezia-vpn/amneziawg-linux-kernel-module"
SRC_URI="https://github.com/amnezia-vpn/amneziawg-linux-kernel-module/tarball/069c78967197d9a0267083203759803fecd75c08 -> amneziawg-linux-kernel-module-1.0.20240711-069c789.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

post_src_unpack() {
    mv ${WORKDIR}/amnezia-vpn-amneziawg-linux-kernel-module-* ${S} || die
}

src_compile() {
    ln -s ${KV_DIR} src/kernel

    local modlist=(amneziawg=kernel/drivers/net:src:src:all)

    linux-mod-r1_src_compile
}