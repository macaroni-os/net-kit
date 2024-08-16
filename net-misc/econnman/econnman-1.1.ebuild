# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )

inherit python-single-r1

DESCRIPTION="ConnMan User Interface written with EFL & python"
HOMEPAGE="https://phab.enlightenment.org/w/projects/econnman/ https://www.enlightenment.org/"
SRC_URI="https://download.enlightenment.org/rel/apps/econnman/econnman-1.1.tar.xz -> econnman-1.1.tar.xz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="*"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="
	${DEPEND}
	dev-libs/efl[X,connman]
	dev-python/python-efl[${PYTHON_USEDEP}]
"

src_prepare() {
	default
	python_fix_shebang econnman-bin.in
}