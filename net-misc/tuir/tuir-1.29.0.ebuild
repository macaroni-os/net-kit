# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3+ )
PYTHON_REQ_USE="ncurses"

inherit distutils-r1

SRC_URI="https://gitlab.com/ajak/tuir/-/archive/v1.29.0/tuir-v1.29.0.tar.gz -> tuir-v1.29.0.tar.gz"
KEYWORDS="*"

DESCRIPTION="Browse Reddit fromy our terminal"
HOMEPAGE="https://gitlab.com/ajak/tuir"
LICENSE="MIT"
SLOT="0"

DEPEND="
	dev-python/beautifulsoup
	dev-python/decorator
	dev-python/kitchen
	dev-python/requests
	dev-python/six
"

S="${WORKDIR}/${PN}-v${PV}"

src_prepare() {
	distutils-r1_src_prepare
}