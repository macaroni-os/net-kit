# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
inherit bash-completion-r1 go-module

DESCRIPTION="A program to sync files to and from various cloud storage providers"
HOMEPAGE="https://rclone.org/"
SRC_URI="
https://api.github.com/repos/rclone/rclone/tarball/v1.73.4 -> rclone-1.73.4-984d07c.tar.gz
mirror://macaroni/rclone-1.73.4-mark-go-bundle-984d07c.tar.xz -> rclone-1.73.4-mark-go-bundle-984d07c.tar.xz"
LICENSE="Apache-2.0 BSD BSD-2 ISC MIT"
SLOT="0"
KEYWORDS="*"
IUSE="+mount"
BDEPEND="dev-lang/go
	
"
RDEPEND="sys-fs/fuse:3
	
"

post_src_unpack() {
	mv rclone-rclone-* ${S}
}


src_compile() {
	go build -mod=mod . || die "compile failed"
}
src_install() {
	dobin ${PN}
	doman ${PN}.1
	dodoc README.md
	./rclone genautocomplete bash ${PN}.bash || die
	newbashcomp ${PN}.bash ${PN}
	./rclone genautocomplete zsh ${PN}.zsh || die
	insinto /usr/share/zsh/site-functions
	newins ${PN}.zsh _${PN}
	use mount && insinto /usr/bin && \
	  doins ${FILESDIR}/rclonefs && \
	  fperms +x /usr/bin/rclonefs
}



# vim: filetype=ebuild
