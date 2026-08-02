# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
FILECAPS=( -m 711 cap_net_bind_service+ep usr/bin/gitea )
inherit fcaps go-module tmpfiles systemd flag-o-matic user

DESCRIPTION="A painless self-hosted Git service"
HOMEPAGE="https://gitea.com https://github.com/go-gitea/gitea"
SRC_URI="
https://api.github.com/repos/go-gitea/gitea/tarball/v1.27.1 -> gitea-1.27.1-a62dfff.tar.gz
mirror://macaroni/gitea-1.27.1-mark-go-bundle-a62dfff.tar.xz -> gitea-1.27.1-mark-go-bundle-a62dfff.tar.xz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
DOCS=(
	custom/conf/app.example.ini
	CHANGELOG.md
	CONTRIBUTING.md
	README.md
)
IUSE="systemd"
RESTRICT="network-sandbox"
# Commons depends
CDEPEND="sys-libs/pam
"
BDEPEND="dev-lang/go
"
RDEPEND="${CDEPEND}
	dev-vcs/git
	
"
DEPEND="${CDEPEND}
	dev-util/pnpm-bin
	
"

post_src_unpack() {
	mv go-gitea-gitea-* ${S}
}


pkg_setup() {
	enewgroup git
	enewuser git -1 /bin/bash /var/lib/gitea git
}
src_prepare() {
	sed -i -e "s#^MODE = console#MODE = file#" custom/conf/app.example.ini || die
	go-module_src_prepare
}
src_configure() {
	# bug 832756 - PIE build issues
	filter-flags -fPIE
	filter-ldflags -fPIE -pie
}
src_compile() {
	local gitea_tags
	local -a gitea_settings makeenv
	gitea_tags="bindata pam sqlite sqlite_unlock_notify"
	gitea_settings=(
	  "-X code.gitea.io/gitea/modules/setting.CustomConf=/etc/gitea/app.ini"
	  "-X code.gitea.io/gitea/modules/setting.CustomPath=/var/lib/gitea/custom"
	  "-X code.gitea.io/gitea/modules/setting.AppWorkPath=/var/lib/gitea"
	)
	export GITEA_VERSION="${PV}"
	makeenv=(
	  LDFLAGS="-extldflags \"${LDFLAGS}\" ${gitea_settings[*]}"
	  TAGS="${gitea_tags}"
	)
	# Use variable STORED_VERSION_FILE (the "${S}/VERSION" file) to set version,
	# and prevent executing git command when it's not a live version.
	makeenv+=( GITHUB_REF_NAME="" )
	env "${makeenv[@]}" emake -j1 frontend
	env "${makeenv[@]}" emake backend
}
src_install() {
	dobin gitea
	einstalldocs
	newconfd "${FILESDIR}/gitea.confd-r1" gitea
	if use systemd ; then
	  systemd_newunit "${FILESDIR}"/gitea.service-r4 gitea.service
	else
	  newinitd "${FILESDIR}/gitea.initd-r3" gitea
	fi
	newtmpfiles - gitea.conf <<-EOF
	  d /run/gitea 0755 git git
	EOF
	insinto /etc/gitea
	newins custom/conf/app.example.ini app.ini
	fowners root:git /etc/gitea/{,app.ini}
	fperms g+w,o-rwx /etc/gitea/{,app.ini}
	diropts -m0750 -o git -g git
	keepdir /var/lib/gitea /var/lib/gitea/custom /var/lib/gitea/data
	keepdir /var/log/gitea
}
pkg_postinst() {
	fcaps_pkg_postinst
	tmpfiles_process gitea.conf
}



# vim: filetype=ebuild
