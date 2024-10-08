# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A manager for BetterDiscord on Linux"
HOMEPAGE="https://github.com/bb010g/betterdiscordctl"
SRC_URI="https://github.com/bb010g/betterdiscordctl/archive/v2.0.1.tar.gz -> betterdiscordctl-2.0.1.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE=""

src_install() {
	dobin ${PN}
}