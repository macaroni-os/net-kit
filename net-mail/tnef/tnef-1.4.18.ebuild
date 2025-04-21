# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="Decodes MS-TNEF MIME attachments"
HOMEPAGE="https://github.com/verdammelt/tnef/"
SRC_URI="https://github.com/verdammelt/tnef/archive/1.4.18.tar.gz -> tnef-1.4.18.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="*"

src_prepare() {
        default

        eautoreconf
}

src_test() {
        emake -j1 check
}
