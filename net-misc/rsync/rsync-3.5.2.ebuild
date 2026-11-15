# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
inherit autotools systemd

DESCRIPTION="File transfer program to keep remote files into sync"
HOMEPAGE="https://rsync.samba.org/"
SRC_URI="https://github.com/RsyncProject/rsync/releases/download/v3.5.2/rsync-3.5.2.tar.gz -> rsync-3.5.2.tar.gz"
LICENSE="GPL-3 GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="acl examples iconv idn ipv6 lz4 ssl stunnel systemd system-zlib xattr xxhash zstd"
RDEPEND=">=dev-libs/popt-1.5
	acl? ( virtual/acl )
	iconv? ( virtual/libiconv )
	idn? ( net-dns/libidn2:= )
	lz4? ( app-arch/lz4 )
	ssl? ( dev-libs/openssl:0= )
	system-zlib? ( sys-libs/zlib )
	xattr? ( kernel_linux? ( sys-apps/attr ) )
	xxhash? ( dev-libs/xxhash )
	zstd? ( app-arch/zstd )
	
"
DEPEND="${RDEPEND}
"
src_compile() {
	rm -f proto.h-tstamp
	make proto || die
	emake || die
}

src_configure() {
	local myeconfargs=(
		--with-rsyncd-conf="/etc/rsyncd.conf"
		--without-included-popt
		--without-rrsync
		--disable-md2man
		$(use_enable acl acl-support)
		$(use_enable iconv)
		$(use_enable idn)
		$(use_enable ipv6)
		$(use_enable lz4)
		$(use_enable ssl openssl)
		$(use_with !system-zlib included-zlib)
		$(use_enable xattr xattr-support)
		$(use_enable xxhash)
		$(use_enable zstd)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" install

	if use systemd ; then
		systemd_dounit "${FILESDIR}/rsyncd.service"
	else
		newconfd "${FILESDIR}/rsyncd.conf.d" rsyncd
		newinitd "${FILESDIR}/rsyncd.init.d-r1" rsyncd
	fi

	dodoc NEWS.md README.md TODO tech_report.tex

	insinto /etc
	newins "${FILESDIR}/rsyncd.conf-3.0.9-r1" rsyncd.conf

	insinto /etc/logrotate.d
	newins "${FILESDIR}/rsyncd.logrotate" rsyncd

	insinto /etc/xinetd.d
	newins "${FILESDIR}/rsyncd.xinetd-3.0.9-r1" rsyncd

	if use stunnel ; then
		emake DESTDIR="${D}" install-ssl-daemon
	fi

	if use examples ; then
		exeinto /usr/share/rsync
		doexe support/*
		rm -f "${ED}"/usr/share/rsync/{Makefile*,*.c}
	fi
}

pkg_postinst() {
	if grep -Eqis '^[[:space:]]use chroot[[:space:]]*=[[:space:]]*(no|0|false)' \
		"${EROOT}"/etc/rsyncd.conf "${EROOT}"/etc/rsync/rsyncd.conf ; then
		ewarn "You have disabled chroot support in your rsyncd.conf. This"
		ewarn "is a security risk which you should fix. Please check your"
		ewarn "/etc/rsyncd.conf file and fix the setting 'use chroot'."
	fi
	if use stunnel ; then
		einfo "Please install \">=net-misc/stunnel-4\" in order to use stunnel feature."
		einfo
		einfo "You maybe have to update the certificates configured in"
		einfo "${EROOT}/etc/stunnel/rsync.conf"
	fi
}


# vim: filetype=ebuild
