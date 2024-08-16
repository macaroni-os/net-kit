# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit distutils-r1

DESCRIPTION="Object-oriented filesystem paths"
HOMEPAGE="https://github.com/jazzband/pathlib2 https://pypi.org/project/pathlib2/"
SRC_URI="https://files.pythonhosted.org/packages/31/51/99caf463dc7c18eb18dad1fffe465a3cf3ee50ac3d1dccbd1781336fe9c7/pathlib2-2.3.7.post1.tar.gz -> pathlib2-2.3.7.post1.tar.gz"

DEPEND="$(python_gen_cond_dep 'dev-python/setuptools[${PYTHON_USEDEP}]' -3)"
IUSE=""
SLOT="0"
LICENSE="MIT"
KEYWORDS="*"
S="${WORKDIR}/pathlib2-2.3.7.post1"