# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake user

DESCRIPTION="Postfix Sender Rewriting Scheme daemon"
SRC_URI="https://github.com/roehling/postsrsd/tarball/74eec372121849c0f794008b0e5a880f0e2f2a7a -> postsrsd-1.12-74eec37.tar.gz"
HOMEPAGE="https://github.com/roehling/postsrsd"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="mail-mta/postfix"

BDEPEND="sys-apps/help2man"

CHROOT_DIR="${EPREFIX}/var/lib/postsrsd"

post_src_unpack() {
    if [ ! -d "${S}" ] ; then
        mv ${WORKDIR}/roehling-* ${S} || die
    fi
}

src_configure() {
	local mycmakeargs=(
		-DCHROOT_DIR="${CHROOT_DIR}"

		# This doesn't affect functionality on OpenRC, it just
		# forces the build system to install the systemd units.
		# -DINIT_FLAVOR="systemd"
		# -DSYSD_UNIT_DIR="$(systemd_get_systemunitdir)"

		-DDOC_DIR="${EPREFIX}"/usr/share/doc/${PF}
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	newinitd "${FILESDIR}"/postsrsd.init postsrsd
	newconfd "${BUILD_DIR}"/postsrsd.default postsrsd
	keepdir "${CHROOT_DIR}"
}