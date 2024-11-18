# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

EGO_SUM=(

)

go-module_set_globals
EGO_SKIP_TIDY=1

DESCRIPTION="Fast tool to manage MinIO clusters"
HOMEPAGE="https://min.io/ https://github.com/minio/mc"
SRC_URI="
https://github.com/minio/mc/tarball/93606cc9894344135f249e40bdd28a635a221284 -> mc-2024.11.17-93606cc.tar.gz"

MY_PV="$(ver_cut 1-3)T$(ver_cut 4-7)Z"
MY_PV=${MY_PV//./-}
EGIT_COMMIT=""
IUSE=""
LICENSE="AGPL-3.0"
SLOT="0"
KEYWORDS="*"

BDEPEND="dev-lang/go"

src_prepare() {
	default

	sed -i -e "s/time.Now().UTC().Format(time.RFC3339)/\"${MY_PV}\"/"\
		-e "s/-s //"\
		-e "/time/d"\
		-e "s/+ commitID()/+ \"${EGIT_COMMIT}\"/"\
		buildscripts/gen-ldflags.go || die
}

src_unpack() {
	go-module_src_unpack
	mv ${WORKDIR}/minio-mc-* ${S} || die
}

src_compile() {
	unset XDG_CACHE_HOME

	MINIO_RELEASE="${MY_PV}"
	go run buildscripts/gen-ldflags.go
	CGO_ENABLED=0 \
		go build --ldflags "$(go run buildscripts/gen-ldflags.go)" -o mc || die
}

src_install() {
	dobin mc
}

# vim: filetype=ebuild