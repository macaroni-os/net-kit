# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
inherit autotools toolchain-funcs flag-o-matic systemd user

DESCRIPTION="Network Time Protocol suite/programs"
HOMEPAGE="http://www.ntp.org/"
SRC_URI="https://downloads.nwtime.org/ntp/4.2.8/ntp-4.2.8p18.tar.gz -> ntp-4.2.8p18.tar.gz"
LICENSE="HPND BSD ISC"
SLOT="0"
KEYWORDS="*"
PATCHES=(
	"${FILESDIR}/ntp-4.2.8_p18-ipc-caps.patch"
	"${FILESDIR}/ntp-4.2.8-sntp-test-pthreads.patch"
	"${FILESDIR}/ntp-4.2.8_p14-add_cap_ipc_lock.patch"
	"${FILESDIR}/ntp-4.2.8_p15-configure-clang16.patch"
	"${FILESDIR}/ntp-4.2.8_p18-c99.patch"
	"${FILESDIR}/ntp-4.2.8_p18-r2-bind-fail-NULL-dereference.patch"
	"${FILESDIR}/ntp-4.2.8-configure.patch"
)
IUSE="caps debug ipv6 ntp-cron parse-clocks readline samba systemd snmp ssl +threads vim-syntax zeroconf"
# Commons depends
CDEPEND="readline? ( sys-libs/readline:= )
	dev-libs/libevent:=[threads?]
	caps? ( sys-libs/libcap )
	zeroconf? ( net-dns/avahi[mdnsresponder-compat] )
	snmp? ( net-analyzer/net-snmp )
	ssl? ( dev-libs/openssl:= )
	parse-clocks? ( net-misc/pps-tools )
	
"
RDEPEND="${CDEPEND}
	vim-syntax? ( app-vim/ntp-syntax )
	
"
DEPEND="${CDEPEND}
	virtual/pkgconfig
	
"
S="${WORKDIR}/ntp-4.2.8p18"
pkg_setup() {
	enewgroup ntp 123
	enewuser ntp 123 -1 /dev/null ntp
}

src_prepare() {
	default
	# Make sure every build uses the same install layout.
	find sntp/loc/ -type f '!' -name legacy -delete || die

	eautoreconf

	# Disable pointless checks.
	touch .checkChangeLog .gcc-warning FRC.html html/.datecheck
}

src_configure() {
	filter-lto

	append-cppflags -D_GNU_SOURCE
	append-cflags -fno-strict-overflow
	append-lfs-flags

	# avoid libmd5/libelf
	export ac_cv_search_MD5Init=no ac_cv_header_md5_h=no
	export ac_cv_lib_elf_nlist=no
	export ac_cv_header_dns_sd_h=$(usex zeroconf)
	export ac_cv_lib_dns_sd_DNSServiceRegister=${ac_cv_header_dns_sd_h}
	export PATH_RUBY=/bin/false
	# Increase the default memlimit from 32MiB to 128MiB.  #533232
	local myeconfargs=(
		--with-lineeditlibs=readline,edit,editline
		--with-yielding-select
		--disable-local-libevent
		--docdir='$(datarootdir)'/doc/${PF}
		--htmldir='$(docdir)/html'
		--with-memlock=256
		--with-hardenfile=/dev/null
		$(use_enable caps linuxcaps)
		$(use_enable parse-clocks)
		$(use_enable ipv6)
		$(use_enable debug debugging)
		$(use_with readline lineeditlibs readline)
		$(use_enable samba ntp-signd)
		$(use_with snmp ntpsnmpd)
		$(use_with ssl crypto)
		$(use_enable threads thread-support)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	# move ntpd/ntpdate to sbin #66671
	dodir /usr/sbin
	mv "${ED}"/usr/bin/{ntpd,ntpdate} "${ED}"/usr/sbin/ || die "move to sbin"

	dodoc INSTALL WHERE-TO-START

	insinto /etc
	doins "${FILESDIR}"/ntp.conf

	use ipv6 || sed -i '/^restrict .*::1/d' "${ED}"/etc/ntp.conf

	newconfd "${FILESDIR}"/ntpd.confd ntpd
	newconfd "${FILESDIR}"/ntp-client.confd ntp-client
	newconfd "${FILESDIR}"/sntp.confd sntp
	if ! use caps ; then
		sed -i "s|-u ntp:ntp||" "${ED}"/etc/conf.d/ntpd || die
	fi

	keepdir /var/lib/ntp
	use prefix || fowners ntp:ntp /var/lib/ntp

	if use ntp-cron ; then
			exeinto /etc/cron.daily
			newexe "${FILESDIR}"/net-client.sh net-client.sh
	fi

	if use systemd ; then
		newtmpfiles "${FILESDIR}"/ntp.tmpfiles ntp.conf
		systemd_newunit "${FILESDIR}"/ntpd.service ntpd.service
		if use caps ; then
			sed -i '/ExecStart/ s|$| -u ntp:ntp|' \
				"${D}$(systemd_get_systemunitdir)"/ntpd.service \
				|| die
		fi
		systemd_enable_ntpunit 60-ntpd ntpd.service

		systemd_newunit "${FILESDIR}"/ntpdate.service ntpdate.service
		systemd_install_serviced "${FILESDIR}"/ntpdate.service.conf
		systemd_newunit "${FILESDIR}"/sntp.service sntp.service
		systemd_install_serviced "${FILESDIR}"/sntp.service.conf

	else
		newinitd "${FILESDIR}"/ntpd.rc-r1 ntpd
		newinitd "${FILESDIR}"/sntp.rc sntp
		newinitd "${FILESDIR}"/ntp-client.rc ntp-client
		sed -i "s:/usr/bin:/usr/sbin:" "${ED}"/etc/init.d/ntpd || die
	fi

}

pkg_postinst() {
	if grep -qs '^[^#].*notrust' "${EROOT}"/etc/ntp.conf ; then
		eerror "The notrust option was found in your /etc/ntp.conf!"
		ewarn "If your ntpd starts sending out weird responses,"
		ewarn "then make sure you have keys properly setup."
	fi
}


# vim: filetype=ebuild
