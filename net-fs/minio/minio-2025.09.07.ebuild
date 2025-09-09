# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
EGO_SKIP_TIDY=1
MY_PV="$(ver_cut 1-3)T$(ver_cut 4-7)Z"
MY_PV=${MY_PV//./-}
inherit go-module user systemd

DESCRIPTION="An Amazon S3 compatible object storage server"
HOMEPAGE="https://min.io/ https://github.com/minio/minio"
SRC_URI="
https://api.github.com/repos/minio/minio/tarball/RELEASE.2025-09-07T16-13-09Z -> minio-2025.09.07-07c3a42.tar.gz
mirror://macaroni/minio-2025.09.07-mark-go-bundle-07c3a42.tar.xz -> minio-2025.09.07-mark-go-bundle-07c3a42.tar.xz"
LICENSE="Apache-2.0 BSD BSD-2 MIT MPL-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="systemd"
BDEPEND="dev-lang/go
"
pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} ${PN}
}
src_prepare() {
	default
	sed -i -e "s/time.Now().UTC().Format(time.RFC3339)/\"${MY_PV}\"/"\
	  -e "s/-s //"\
	  -e "/time/d"\
	  -e "s/+ commitID()/+ \"07c3a429bfed433e49018cb0f78a52145d4bedeb\"/"\
	  buildscripts/gen-ldflags.go || die
}
src_unpack() {
	go-module_src_unpack
	mv ${WORKDIR}/minio-minio-* ${S} || die
}
src_compile() {
	unset XDG_CACHE_HOME
	MINIO_RELEASE="${MY_PV}"
	go run buildscripts/gen-ldflags.go
	CGO_ENABLED=0 \
	  go build --ldflags "$(go run buildscripts/gen-ldflags.go)" -o ${PN} || die
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
