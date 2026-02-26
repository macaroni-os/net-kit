# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
inherit bash-completion-r1 systemd toolchain-funcs

DESCRIPTION="Required tools for WireGuard, such as wg(8) and wg-quick(8)"
HOMEPAGE="https://www.wireguard.com/"
SRC_URI="https://api.github.com/repos/WireGuard/wireguard-tools/tarball/refs/tags/v1.0.20260223 -> wireguard-tools-1.0.20260223-49ce333.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="systemd"
BDEPEND="virtual/pkgconfig
"

post_src_unpack() {
	mv WireGuard-wireguard-tools-* ${S}
}


src_compile() {
	emake RUNSTATEDIR="${EPREFIX}/run" \
	  -C src CC="$(tc-getCC)" LD="$(tc-getLD)"
}
src_install() {
	local emakeargs=(
	  WITH_BASHCOMPLETION=yes
	  WITH_WGQUICK=yes
	  DESTDIR="${D}"
	  BASHCOMPDIR="$(get_bashcompdir)"
	  SYSTEMDUNITDIR="$(systemd_get_systemunitdir)"
	  PREFIX="${EPREFIX}/usr"
	)
	 if use systemd ; then
	  emakeargs+=(
	    WITH_SYSTEMDUNITS=yes
	  )
	else
	  emakeargs+=(
	    WITH_SYSTEMDUNITS=no
	  )
	fi
	 dodoc README.md
	dodoc -r contrib
	emake "${emakeargs[@]}" -C src install
	 if ! use systemd ; then
	  newinitd "${FILESDIR}"/wg-quick.initd wg-quick
	fi
}



# vim: filetype=ebuild
