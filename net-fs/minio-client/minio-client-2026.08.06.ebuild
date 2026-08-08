# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
EGO_SKIP_TIDY=1
MY_PV="$(ver_cut 1-3)T$(ver_cut 4-7)Z"
MY_PV=${MY_PV//./-}
inherit go-module

DESCRIPTION="Fast tool to manage MinIO clusters (Pgsty Fork)"
HOMEPAGE="https://github.com/pgsty/minio"
SRC_URI="
https://api.github.com/repos/pgsty/mc/tarball/RELEASE.2026-08-06T00-00-00Z -> minio-client-2026.08.06-b0021fd.tar.gz
mirror://macaroni/minio-client-2026.08.06-mark-go-bundle-b0021fd.tar.xz -> minio-client-2026.08.06-mark-go-bundle-b0021fd.tar.xz"
LICENSE="AGPL-3.0"
SLOT="0"
KEYWORDS="*"
BDEPEND="dev-lang/go
"
src_unpack() {
	go-module_src_unpack
	mv ${WORKDIR}/pgsty-mc-* ${S} || die
}
src_compile() {
	unset XDG_CACHE_HOME
	MINIO_RELEASE="${MY_PV}"
	local minio_ldflags=(
	  "-X \"github.com/minio/mc/cmd.Version=${MY_PV}\""
	  "-X github.com/minio/mc/cmd.CommitID=b0021fd01ccb4a7d62cc1844a184265027ef2d9d"
	  "-X github.com/minio/mc/cmd.ReleaseTag=\"${PV}\""
	)
	CGO_ENABLED=0 go build -ldflags "${minio_ldflags[*]}" -o mc || die
}
src_install() {
	dobin mc
}


# vim: filetype=ebuild
