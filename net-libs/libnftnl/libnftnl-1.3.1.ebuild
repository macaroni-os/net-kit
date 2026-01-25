# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
inherit autotools toolchain-funcs

DESCRIPTION="Netlink API to the in-kernel nf_tables subsystem"
HOMEPAGE="https://netfilter.org/projects/libnftnl/"
SRC_URI="https://www.netfilter.org/pub/libnftnl/libnftnl-1.3.1.tar.xz -> libnftnl-1.3.1.tar.xz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="examples static-libs"
BDEPEND="virtual/pkgconfig
"
RDEPEND=">=net-libs/libmnl-1.0.4
	
"
DEPEND="${RDEPEND}
"
src_configure() {
	local myeconfargs=(
	  $(use_enable static-libs static)
	)
	econf "${myeconfargs[@]}"
}
src_install() {
	default
	gen_usr_ldscript -a nftnl
	find "${ED}" -type f -name '*.la' -delete || die
	if use examples; then
	  find examples/ -name 'Makefile*' -delete || die "Could not rm examples"
	  dodoc -r examples
	  docompress -x /usr/share/doc/${PF}/examples
	fi
}


# vim: filetype=ebuild
