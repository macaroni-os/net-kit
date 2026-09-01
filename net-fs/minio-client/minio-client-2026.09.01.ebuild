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
https://api.github.com/repos/pgsty/mc/tarball/RELEASE.2026-09-01T00-00-00Z -> minio-client-2026.09.01-ddac5d5.tar.gz
mirror://macaroni/minio-client-2026.09.01-mark-go-bundle-ddac5d5.tar.xz -> minio-client-2026.09.01-mark-go-bundle-ddac5d5.tar.xz"
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
		"-X github.com/minio/mc/cmd.CommitID=ddac5d58ab4925f3cde4bf99625e94cd47934026"
		"-X github.com/minio/mc/cmd.ReleaseTag=\"${PV}\""
	)
	CGO_ENABLED=0 go build -ldflags "${minio_ldflags[*]}" -o mc || die
}
src_install() {
	dobin mc
}


# vim: filetype=ebuild
