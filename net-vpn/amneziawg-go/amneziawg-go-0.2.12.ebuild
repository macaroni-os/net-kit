# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

DESCRIPTION="AmneziaWG VPN protocol"
HOMEPAGE="https://github.com/amnezia-vpn/amneziawg-go"
SRC_URI="https://github.com/amnezia-vpn/amneziawg-go/tarball/2e3f7d122ca8ef61e403fddc48a9db8fccd95dbf -> amneziawg-go-0.2.12-2e3f7d1.tar.gz
https://distfiles.macaronios.org/18/a1/b3/18a1b3ecb3f0b8985c6651d76c115c32776c86f0dd8b1d9faedc6ce88014e85f06fbd18ba9089caf9c70e9ad4d0ee3c2d73df8dde08d00283b137fb609895148 -> amneziawg-go-0.2.12-funtoo-go-bundle-8339e4c2c3f03f5dd55137c8511c86d09d500cedd328fc17ec0984c3fc322d04272aebac6bcb19ab5b3da1a26c998a089dbeaea74733da0476e765bbee33d055.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"

post_src_unpack() {
    mv ${WORKDIR}/amnezia-vpn-amneziawg-go-* ${S} || die
}