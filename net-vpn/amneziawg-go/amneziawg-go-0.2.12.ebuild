# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

DESCRIPTION="AmneziaWG VPN protocol"
HOMEPAGE="https://github.com/amnezia-vpn/amneziawg-go"
SRC_URI="https://github.com/amnezia-vpn/amneziawg-go/tarball/2e3f7d122ca8ef61e403fddc48a9db8fccd95dbf -> amneziawg-go-0.2.12-2e3f7d1.tar.gz
https://distfiles.macaronios.org/47/4e/4e/474e4e8db831ee315c92dd04fdc05e8e8054cb87d7b0df0e380f658b560b392726f4343346411606683c83d6ce640bf93cadd911a19cb359a4016016399e6afe -> amneziawg-go-0.2.12-funtoo-go-bundle-8339e4c2c3f03f5dd55137c8511c86d09d500cedd328fc17ec0984c3fc322d04272aebac6bcb19ab5b3da1a26c998a089dbeaea74733da0476e765bbee33d055.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"

post_src_unpack() {
    mv ${WORKDIR}/amnezia-vpn-amneziawg-go-* ${S} || die
}