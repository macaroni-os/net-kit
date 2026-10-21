# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
EGO_SKIP_TIDY=1
EGO_OVERRIDE_GOMOD=0
MY_PV="$(ver_cut 1-3)T$(ver_cut 4-7)Z"
MY_PV=${MY_PV//./-}
inherit go-module user systemd

DESCRIPTION="An Amazon S3 compatible object storage server (Pgsty Fork)"
HOMEPAGE="https://github.com/pgsty/silo"
SRC_URI="
https://api.github.com/repos/pgsty/silo/tarball/RELEASE.2026-09-16T00-00-00Z -> silo-2026.09.16-2a4d514.tar.gz
mirror://macaroni/silo-2026.09.16-mark-go-bundle-2a4d514.tar.xz -> silo-2026.09.16-mark-go-bundle-2a4d514.tar.xz"
LICENSE="AGPL-3.0"
SLOT="0"
KEYWORDS="*"
IUSE="systemd"
BDEPEND="dev-lang/go
"
pkg_setup() {
	enewgroup silo
	enewuser silo -1 -1 /var/lib/silo silo
}
src_unpack() {
	go-module_src_unpack
	mv ${WORKDIR}/pgsty-silo-* ${S} || die
}
src_compile() {
	unset XDG_CACHE_HOME
	export SILO_RELEASE="${MY_PV}"
	local silo_ldflags=(
					"-X github.com/pgsty/silo/cmd.Version=${MINIO_RELEASE}"
					"-X github.com/pgsty/silo/cmd.CopyrightYear=$(date -u '+%Y')"
					"-X github.com/pgsty/silo/cmd.ReleaseTag=\"${PV}\""
					"-X github.com/pgsty/silo/cmd.CommitID=2a4d51406b7ed87af5fe6fe0f801f3290f96eb3c"
					"-X github.com/pgsty/silo/cmd.ShortCommitID=2a4d514"
	)
	CGO_ENABLED=0 \
		go build --ldflags "${silo_ldflags[*]}" -o ${PN} || die
}
src_install() {
	dobin ${PN}
	insinto /etc/"${PN}"
	dodoc -r README.md CONTRIBUTING.md docs
	if use systemd ; then
		systemd_dounit "${FILESDIR}"/silo.service
	else
		newinitd "${FILESDIR}"/silo.initd silo
	fi
	newconfd "${FILESDIR}"/"${PN}".confd ${PN}
	keepdir /var/{lib,log}/"${PN}"
	# for now keep minio user
	fowners minio:minio /
}


# vim: filetype=ebuild
