# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
EGO_SKIP_TIDY=1
inherit go-module systemd

DESCRIPTION="Gogs is a painless self-hosted Git service"
HOMEPAGE="https://gogs.io"
SRC_URI="
https://api.github.com/repos/gogs/gogs/tarball/v0.14.2 -> gogs-0.14.2-5dcb6c6.tar.gz
mirror://macaroni/gogs-0.14.2-mark-go-bundle-5dcb6c6.tar.xz -> gogs-0.14.2-mark-go-bundle-5dcb6c6.tar.xz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
DOCS=(
	CHANGELOG.md
	README.md
	SECURITY.md
)
IUSE="pam cert mysql postgres +sqlite ssh systemd"
# Commons depends
CDEPEND="pam? (
	  sys-libs/pam
	)
	
"
BDEPEND="dev-lang/go
"
RDEPEND="${CDEPEND}
	dev-vcs/git
	ssh? ( net-misc/openssh )
	mysql? (
	  || (
	    dev-db/mariadb
	    dev-db/mysql-community
	  )
	)
	postgres? ( dev-db/postgresql )
	sqlite? ( dev-db/sqlite )
	
"
DEPEND="${CDEPEND}
"

post_src_unpack() {
	mv gogs-gogs-* ${S}
}


src_compile() {
	local tags=()
	local custom_flags=()
	 if use pam ; then
	  tags+=( pam )
	fi
	if use cert ; then
	  tags+=( cert )
	fi
	 if [ "${#tags[@]}" != "0" ] ; then
	  custom_flags=(-tags "${tags[@]}" )
	fi
	 local withcgo="0"
	if use sqlite ; then
	  # Sqlite requires CGO
	  withcgo="1"
	fi
	CGO_ENABLED=${withcgo} go build ${custom_ldflags[*]} \
	  -o ${PN} -v -x . || die
}
src_install() {
	dobin gogs
	einstalldocs
	newconfd "${FILESDIR}/gogs.confd" gogs
	if use systemd ; then
	  systemd_newunit "${FILESDIR}"/gogs.service gogs.service
	else
	  newinitd "${FILESDIR}/gogs.initd" gogs
	fi
	insinto /usr/share/gogs/
	newins conf/app.ini app.example.ini
	insinto /usr/share/gogs/auth.d
	for i in conf/auth.d/*.example ; do
	  doins ${i}
	done
	diropts -m0750 -o git -g git
	keepdir /var/lib/gogs /var/lib/gogs/custom/https /var/log/gogs /etc/gogs
}



# vim: filetype=ebuild
