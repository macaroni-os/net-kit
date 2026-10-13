# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
inherit autotools pam user xdg

DESCRIPTION="CUPS - Common Unix Printing System"
HOMEPAGE="https://github.com/OpenPrinting/cups"
SRC_URI="https://github.com/OpenPrinting/cups/releases/download/v2.4.19/cups-2.4.19-source.tar.gz -> cups-2.4.19.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
PATCHES=(
	"${FILESDIR}/cups-nostrip.patch"
)
IUSE="acl dbus debug kerberos openssl pam static-libs usb X xinetd zeroconf"
RDEPEND="app-text/libpaper
	sys-libs/zlib
	acl? (
	    kernel_linux? (
	        sys-apps/acl
	        sys-apps/attr
	    )
	)
	dbus? ( sys-apps/dbus )
	kerberos? ( virtual/krb5 )
	!openssl? ( net-libs/gnutls:0= )
	openssl? ( dev-libs/openssl )
	pam? ( virtual/pam )
	usb? ( virtual/libusb:1 )
	X? ( x11-misc/xdg-utils )
	xinetd? ( sys-apps/xinetd )
	zeroconf? ( net-dns/avahi )
	
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	
"
PDEPEND="net-print/cups-filters
	
"
pkg_setup() {
	  enewgroup lp
	  enewuser lp -1 -1 -1 lp
	  enewgroup lpadmin 106
}

src_prepare() {
	  default
	   # Remove ".SILENT" rule for verbose output (bug 524338).
	  sed 's#^.SILENT:##g' -i "${S}"/Makedefs.in || die "sed failed"
	   AT_M4DIR=config-scripts eaclocal
	  eautoconf
}

src_configure() {
	  export DSOFLAGS="${LDFLAGS}"
	   einfo LINGUAS=\"${LINGUAS}\"
	   # explicitly specify compiler wrt bug 524340
	  #
	  # need to override KRB5CONFIG for proper flags
	  # https://github.com/apple/cups/issues/4423
	  local myeconfargs=(
	      CC="$(tc-getCC)"
	      CXX="$(tc-getCXX)"
	      KRB5CONFIG="${EPREFIX}"/usr/bin/${CHOST}-krb5-config
	      --libdir="${EPREFIX}"/usr/$(get_libdir)
	      --localstatedir="${EPREFIX}"/var
	      --with-exe-file-perm=755
	      --with-rundir="${EPREFIX}"/run/cups
	      --with-cups-user=lp
	      --with-cups-group=lp
	      --with-dnssd=$(usex zeroconf avahi no)
	      --with-docdir="${EPREFIX}"/usr/share/cups/html
	      --with-languages="${LINGUAS}"
	      --with-pkgconfpath="${EPREFIX}"/usr/$(get_libdir)/pkgconfig
	      --with-system-groups=lpadmin
	      --with-tls=$(usex openssl openssl gnutls)
	      --with-xinetd="${EPREFIX}"/etc/xinetd.d
	      $(use_enable acl)
	      $(use_enable dbus)
	      $(use_enable debug)
	      $(use_enable debug debug-guards)
	      $(use_enable debug debug-printfs)
	      $(use_enable kerberos gssapi)
	      $(use_enable pam)
	      $(use_enable static-libs static)
	      $(use_enable usb libusb)
	      --enable-libpaper
	  )
	   if tc-is-static-only; then
	      myeconfargs+=(
	          --disable-shared
	      )
	  fi
	   econf "${myeconfargs[@]}"
	   # install in /usr/libexec always, instead of using /usr/lib/cups, as that
	  # makes more sense when facing multilib support.
	  sed -i -e "s:SERVERBIN.*:SERVERBIN = \"\$\(BUILDROOT\)${EPREFIX}/usr/libexec/cups\":" Makedefs || die
	  sed -i -e "s:#define CUPS_SERVERBIN.*:#define CUPS_SERVERBIN \"${EPREFIX}/usr/libexec/cups\":" config.h || die
	  sed -i -e "s:cups_serverbin=.*:cups_serverbin=\"${EPREFIX}/usr/libexec/cups\":" cups-config || die
	   # additional path corrections needed for prefix, see bug 597728
	  sed \
	      -e "s:ICONDIR.*:ICONDIR = ${EPREFIX}/usr/share/icons:" \
	      -e "s:INITDIR.*:INITDIR = ${EPREFIX}/etc:" \
	      -e "s:DBUSDIR.*:DBUSDIR = ${EPREFIX}/etc/dbus-1:" \
	      -e "s:MENUDIR.*:MENUDIR = ${EPREFIX}/usr/share/applications:" \
	      -i Makedefs || die
}

src_install() {
	  emake BUILDROOT="${D}" install
	   dodoc {CHANGES,CREDITS,README}.md
	   # move the default config file to docs
	  dodoc "${ED}"/etc/cups/cupsd.conf.default
	  rm -f "${ED}"/etc/cups/cupsd.conf.default
	   # clean out cups init scripts
	  rm -rf "${ED}"/etc/{init.d/cups,rc*,pam.d/cups}
	   # install our init script
	  local neededservices
	  use zeroconf && neededservices+=" avahi-daemon"
	  use dbus && neededservices+=" dbus"
	  [[ -n ${neededservices} ]] && neededservices="need${neededservices}"
	  cp "${FILESDIR}"/cupsd.init.d "${T}"/cupsd || die
	  sed -i \
	      -e "s/@neededservices@/${neededservices}/" \
	      "${T}"/cupsd || die
	  doinitd "${T}"/cupsd
	   # install our pam script
	  pamd_mimic_system cups auth account
	   if use xinetd ; then
	      # correct path
	      sed -i \
	          -e "s:server = .*:server = /usr/libexec/cups/daemon/cups-lpd:" \
	          "${ED}"/etc/xinetd.d/cups-lpd || die
	      # it is safer to disable this by default, bug #137130
	      grep -w 'disable' "${ED}"/etc/xinetd.d/cups-lpd || \
	          { sed -i -e "s:}:\tdisable = yes\n}:" "${ED}"/etc/xinetd.d/cups-lpd || die ; }
	      # write permission for file owner (root), bug #296221
	      fperms u+w /etc/xinetd.d/cups-lpd || die "fperms failed"
	  else
	      # always configure with --with-xinetd= and clean up later,
	      # bug #525604
	      rm -rf "${ED}"/etc/xinetd.d
	  fi
	   keepdir /usr/libexec/cups/driver /usr/share/cups/{model,profiles} \
	      /var/log/cups /var/spool/cups/tmp
	   keepdir /etc/cups/{interfaces,ppd,ssl}
	   if ! use X ; then
	      rm -r "${ED}"/usr/share/applications || die
	  fi
	   # create /etc/cups/client.conf, bug #196967 and #266678
	  echo "ServerName ${EPREFIX}/run/cups/cups.sock" >> "${ED}"/etc/cups/client.conf
	   # the following file is now provided by cups-filters:
	  rm -r "${ED}"/usr/share/cups/banners || die
	   # the following are created by the init script
	  rm -r "${ED}"/var/cache/cups || die
	  rm -r "${ED}"/run || die
}

pkg_preinst() {
	  xdg_pkg_preinst
}

pkg_postinst() {
	  # Update desktop file database and gtk icon cache (bug 370059)
	  xdg_pkg_postinst
	   local v
	   for v in ${REPLACING_VERSIONS}; do
	      if ! ver_test ${v} -ge 2.2.2-r2 ; then
	          echo
	          ewarn "The cupsd init script switched to using pidfiles. Shutting down"
	          ewarn "cupsd will fail the next time. To fix this, please run once as root"
	          ewarn "   killall cupsd ; /etc/init.d/cupsd zap ; /etc/init.d/cupsd start"
	          echo
	          break
	      fi
	  done
	   for v in ${REPLACING_VERSIONS}; do
	      echo
	      elog "For information about installing a printer and general cups setup"
	      elog "take a look at: https://wiki.gentoo.org/wiki/Printing"
	      echo
	      break
	  done
}

pkg_postrm() {
	  # Update desktop file database and gtk icon cache (bug 370059)
	  xdg_pkg_postrm
}


# vim: filetype=ebuild
