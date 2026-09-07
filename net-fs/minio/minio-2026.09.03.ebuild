# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
EGO_SKIP_TIDY=1
EGO_OVERRIDE_GOMOD=0
MY_PV="$(ver_cut 1-3)T$(ver_cut 4-7)Z"
MY_PV=${MY_PV//./-}
inherit go-module user systemd

DESCRIPTION="An Amazon S3 compatible object storage server (Pgsty Fork)"
HOMEPAGE="https://github.com/pgsty/minio"
SRC_URI="
https://api.github.com/repos/pgsty/silo/tarball/RELEASE.2026-09-03T13-18-01Z -> minio-2026.09.03-9b11dc9.tar.gz
mirror://macaroni/minio-2026.09.03-mark-go-bundle-9b11dc9.tar.xz -> minio-2026.09.03-mark-go-bundle-9b11dc9.tar.xz"
LICENSE="AGPL-3.0"
SLOT="0"
KEYWORDS="*"
IUSE="systemd"
BDEPEND="dev-lang/go
"
pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} ${PN}
}
src_unpack() {
	go-module_src_unpack
	mv ${WORKDIR}/pgsty-minio-* ${S} || die
}
src_compile() {
	unset XDG_CACHE_HOME
	export MINIO_RELEASE="${MY_PV}"
	local minio_ldflags=(
					"-X github.com/minio/minio/cmd.Version=${MINIO_RELEASE}"
					"-X github.com/minio/minio/cmd.CopyrightYear=$(date -u '+%Y')"
					"-X github.com/minio/minio/cmd.ReleaseTag=\"${PV}\""
					"-X github.com/minio/minio/cmd.CommitID=9b11dc9469e650815b775cb47b039610644f5da4"
					"-X github.com/minio/minio/cmd.ShortCommitID=9b11dc9"
	)
	CGO_ENABLED=0 \
		go build --ldflags "${minio_ldflags[*]}" -o ${PN} || die
}
src_install() {
	dobin ${PN}
	insinto /etc/"${PN}"
	dodoc -r README.md CONTRIBUTING.md docs
	if use systemd ; then
		systemd_dounit "${FILESDIR}"/minio.service
	else
		newinitd "${FILESDIR}"/minio.initd minio
	fi
	newconfd "${FILESDIR}"/"${PN}".confd ${PN}
	keepdir /var/{lib,log}/"${PN}"
	fowners minio:minio /
}


# vim: filetype=ebuild
