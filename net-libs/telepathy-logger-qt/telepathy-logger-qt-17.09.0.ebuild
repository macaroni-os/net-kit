# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
QT_MINIMAL=5.12.3
inherit kde5 python-any-r1

DESCRIPTION="Qt bindings for the Telepathy logger"
HOMEPAGE="https://invent.kde.org/network/telepathy-logger-qt"
SRC_URI="mirror://kde/stable/telepathy-logger-qt/${PV%.*}/src/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="5"
KEYWORDS="*"
IUSE=""

BDEPEND="${PYTHON_DEPS}"
DEPEND="
	dev-libs/dbus-glib
	dev-libs/glib:2
	dev-libs/libxml2
	$(add_qt_dep qtdbus)
	net-im/telepathy-logger
	net-libs/telepathy-glib
	net-libs/telepathy-qt[qt5(+)]
	sys-apps/dbus
"
RDEPEND="${DEPEND}"
