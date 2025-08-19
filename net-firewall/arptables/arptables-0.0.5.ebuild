# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
inherit autotools toolchain-funcs

DESCRIPTION="Set up, maintain, and inspect the tables of ARP rules in the Linux kernel"
HOMEPAGE="https://ebtables.netfilter.org"
SRC_URI="https://www.netfilter.org/pub/arptables/arptables-0.0.5.tar.gz -> arptables-0.0.5.tar.gz"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"
src_compile() {
	# -O0 does not work and at least -O2 is required, bug #240752
	emake CC="$(tc-getCC)" COPT_FLAGS="-O2 ${CFLAGS//-O0/-O2}"
	sed -e 's:__EXEC_PATH__:/sbin:g' \
	  -i arptables-save arptables-restore || die "sed failed"
}
src_install() {
	emake \
	  PREFIX="${ED}"/ \
	  LIBDIR="${ED}/$(get_libdir)" \
	  SYSCONFIGDIR="${ED}"/etc \
	  MANDIR="${ED}"/usr/share/man \
	  install
	newman arptables-legacy.8 arptables.8
}


# vim: filetype=ebuild
