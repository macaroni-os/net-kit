# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
EGO_BUNDLE_POSTFIX="mark-go-bundle"
FILECAPS=( -m 711 cap_net_bind_service+ep usr/bin/forgejo )
inherit fcaps go-module tmpfiles systemd flag-o-matic user

DESCRIPTION="A painless self-hosted Git service"
HOMEPAGE="https://forgejo.org/"
SRC_URI="
https://codeberg.org/forgejo/forgejo/archive/v15.0.7.tar.gz -> forgejo-15.0.7.tar.gz
mirror://macaroni/forgejo-15.0.7-mark-go-bundle.tar.xz -> forgejo-15.0.7-mark-go-bundle.tar.xz"
SLOT="0"
KEYWORDS="*"
DOCS=(
	custom/conf/app.example.ini
	CONTRIBUTING.md
	README.md
)
IUSE="systemd"
RESTRICT="network-sandbox"
# Commons depends
CDEPEND="sys-libs/pam
"
BDEPEND="dev-lang/go
	net-libs/nodejs
	
"
RDEPEND="${CDEPEND}
	dev-vcs/git
	
"
DEPEND="${CDEPEND}
"
S="${WORKDIR}/${PN}"
pkg_setup() {
	enewgroup git
	enewuser git -1 /bin/bash /var/lib/forgejo git
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
	# PAM tags die for this error:
	# transaction.go:409:55: could not determine what C.RTLD_NEXT refers to
	gitea_tags="bindata sqlite sqlite_unlock_notify"
	gitea_settings=(
		"-X forgejo.org/modules/setting.CustomConf=/etc/forgejo/app.ini"
		"-X forgejo.org/modules/setting.CustomPath=/var/lib/forgejo/custom"
		"-X forgejo.org/modules/setting.AppWorkPath=/var/lib/forgejo"
	)
	export FORGEJO_VERSION="${PV}"
	makeenv=(
		LDFLAGS="-extldflags \"${LDFLAGS}\" ${gitea_settings[*]}"
		TAGS="${gitea_tags}"
	)
	# Use variable STORED_VERSION_FILE (the "${S}/VERSION" file) to set version,
	# and prevent executing git command when it's not a live version.
	makeenv+=( GITHUB_REF_NAME="" )
	# We need frontend for assets
	env "${makeenv[@]}" emake -j1 frontend
	env "${makeenv[@]}" emake -j1 backend
}
src_install() {
	newbin gitea forgejo
	einstalldocs
	newconfd "${FILESDIR}/forgejo.confd" forgejo
	if use systemd ; then
		systemd_newunit "${FILESDIR}"/forgejo.service forgejo.service
	else
		newinitd "${FILESDIR}/forgejo.initd" forgejo
	fi
	newtmpfiles - forgejo.conf <<-EOF
		d /run/forgejo 0755 git git
	EOF
	insinto /etc/forgejo
	newins custom/conf/app.example.ini app.ini
	fowners root:git /etc/forgejo/{,app.ini}
	fperms g+w,o-rwx /etc/forgejo/{,app.ini}
	diropts -m0750 -o git -g git
	keepdir /var/lib/forgejo /var/lib/forgejo/custom /var/lib/forgejo/data
	keepdir /var/log/forgejo
}
pkg_postinst() {
	fcaps_pkg_postinst
	tmpfiles_process forgejo.conf
}


# vim: filetype=ebuild
