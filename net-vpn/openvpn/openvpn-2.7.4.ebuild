# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
inherit autotools flag-o-matic user tmpfiles

DESCRIPTION="Robust and highly flexible tunneling application compatible with many OSes"
HOMEPAGE="https://openvpn.net/"
SRC_URI="https://api.github.com/repos/OpenVPN/openvpn/tarball/v2.7.4 -> openvpn-2.7.4-8e9e91f.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="down-root examples inotify iproute2 +openssl +lz4 +lzo mbedtls pam
pkcs11 +plugins selinux static userland_BSD
"
REQUIRED_USE="static? ( !plugins !pkcs11 )
pkcs11? ( !mbedtls )
!plugins? ( !pam !down-root )
inotify? ( plugins )
"
# Commons depends
CDEPEND="kernel_linux? (
	  iproute2? ( sys-apps/iproute2[-minimal] )
	)
	lz4? ( app-arch/lz4 )
	lzo? ( dev-libs/lzo )
	mbedtls? ( net-libs/mbedtls:= )
	openssl? ( dev-libs/openssl )
	pam? ( sys-libs/pam )
	pkcs11? ( dev-libs/pkcs11-helper )
	dev-python/docutils
	dev-libs/libnl:3=
	
"
RDEPEND="selinux? ( sec-policy/selinux-openvpn )
	
"
DEPEND="${CDEPEND}
	dev-python/docutils
	
"

post_src_unpack() {
	mv OpenVPN-openvpn-* ${S}
}


src_prepare() {
	default
	eautoreconf
}
src_configure() {
	  local -a myeconfargs
	  if ! use mbedtls; then
	      myeconfargs+=(
	          $(use_enable pkcs11)
	      )
	  fi
	  myeconfargs+=(
	      $(use_enable inotify async-push)
	      --with-crypto-library=$(usex mbedtls mbedtls openssl)
	      $(use_enable lz4)
	      $(use_enable lzo)
	      $(use_enable plugins)
	      $(use_enable iproute2)
	      $(use_enable pam plugin-auth-pam)
	      $(use_enable down-root plugin-down-root)
	  )
	  TMPFILES_DIR="/usr/lib/tmpfiles.d" \
	      IPROUTE=$(usex iproute2 '/bin/ip' '') \
	      econf "${myeconfargs[@]}"
}
src_install() {
	default
	find "${ED}/usr" -name '*.la' -delete || die
	 # install documentation
	dodoc AUTHORS ChangeLog PORTS README
	 # Install some helper scripts
	keepdir /etc/openvpn
	exeinto /etc/openvpn
	doexe "${FILESDIR}/up.sh"
	doexe "${FILESDIR}/down.sh"
	 # Install the init script and config file
	newinitd "${FILESDIR}/${PN}-2.1.init" openvpn
	newconfd "${FILESDIR}/${PN}-2.1.conf" openvpn
	 # install examples, controlled by the respective useflag
	if use examples ; then
	  # dodoc does not supportly support directory traversal, #15193
	  docinto examples
	  dodoc -r sample contrib
	fi
	 doman doc/openvpn.8
}
pkg_postinst() {
	# Add openvpn user so openvpn servers can drop privs
	# Clients should run as root so they can change ip addresses,
	# dns information and other such things.
	enewgroup openvpn
	enewuser openvpn "" "" "" openvpn
	tmpfiles_process openvpn.conf
	 elog "The openvpn init script expects to find the configuration file"
	elog "openvpn.conf in /etc/openvpn along with any extra files it may need."
	elog ""
	elog "To create more VPNs, simply create a new .conf file for it and"
	elog "then create a symlink to the openvpn init script from a link called"
	elog "openvpn.newconfname - like so"
	elog "   cd /etc/openvpn"
	elog "   ${EDITOR##*/} foo.conf"
	elog "   cd /etc/init.d"
	elog "   ln -s openvpn openvpn.foo"
	elog ""
	elog "You can then treat openvpn.foo as any other service, so you can"
	elog "stop one vpn and start another if you need to."
	 if grep -Eq "^[ \t]*(up|down)[ \t].*" "${ROOT}/etc/openvpn"/*.conf 2>/dev/null ; then
	  ewarn ""
	  ewarn "WARNING: If you use the remote keyword then you are deemed to be"
	  ewarn "a client by our init script and as such we force up,down scripts."
	  ewarn "These scripts call /etc/openvpn/\$SVCNAME-{up,down}.sh where you"
	  ewarn "can move your scripts to."
	fi
	 if use plugins ; then
	  einfo ""
	  einfo "plugins have been installed into /usr/$(get_libdir)/${PN}/plugins"
	fi
}



# vim: filetype=ebuild
