# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
QA_FLAGS_IGNORED="usr/bin/rustfs"
inherit cargo systemd user

DESCRIPTION="A high-performance distributed S3-compatible object storage server"
HOMEPAGE="https://rustfs.com"
SRC_URI="
https://api.github.com/repos/rustfs/rustfs/tarball/1.0.5 -> rustfs-1.0.5-34e6449.tar.gz
https://crates.io/api/v1/crates/zstd/0.14.3/download -> zstd-0.14.3.crate
mirror://macaroni/rustfs-1.0.5-mark-rust-bundle-34e6449.tar.xz -> rustfs-1.0.5-mark-rust-bundle-34e6449.tar.xz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="systemd"
BDEPEND="app-arch/xz-utils
	virtual/pkgconfig
	virtual/rust
	
"
RDEPEND="app-arch/xz-utils:=
	
"
src_unpack() {
	cargo_src_unpack
	rm -rf ${S}
	mv ${WORKDIR}/rustfs-rustfs-* ${S} || die
	# Load the zstd crate declared as asset into the vendored
	# registry: ${A} only gets unpacked, not indexed, by the
	# bundle branch of cargo_src_unpack.
	_cargo_process_crate "${DISTDIR}/zstd-0.14.3.crate"
}

src_configure() {
	# Upstream declares rust-version = 1.99.0 while the kit ships
	# dev-lang/rust 1.98.1; the workspace compiles with the kit
	# toolchain, so only the MSRV gate is ignored. --bin rustfs:
	# the workspace also carries upstream test/tool binaries.
	cargo_src_configure --ignore-rust-version --bin rustfs
}

src_install() {
	local target_dir="${CARGO_TARGET_DIR:-target}/$(usex debug debug release)"
	dobin "${target_dir}/rustfs"

	if use systemd ; then
		systemd_dounit "${FILESDIR}"/rustfs.service
	else
		newinitd "${FILESDIR}"/rustfs.initd rustfs
	fi
	newconfd "${FILESDIR}"/rustfs.confd rustfs

	keepdir /var/lib/rustfs
	fowners rustfs:rustfs /var/lib/rustfs
	fperms 0700 /var/lib/rustfs
}

pkg_setup() {
	# Static uid/gid: macaroni-commons packages/entities/groups.yaml
	enewgroup rustfs 519
	enewuser rustfs 519 -1 /dev/null rustfs
}


# vim: filetype=ebuild
