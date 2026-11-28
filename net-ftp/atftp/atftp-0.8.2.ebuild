# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
inherit autotools flag-o-matic systemd

DESCRIPTION="Advanced TFTP implementation client/server"
HOMEPAGE="https://sourceforge.net/projects/atftp/"
SRC_URI="https://api.github.com/repos/madmartin/atftp/tarball/refs/tags/v0.8.2 -> atftp-0.8.2-63256e4.tar.gz"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"
IUSE="selinux systemd tcpd readline pcre"
RDEPEND="tcpd? ( sys-apps/tcp-wrappers )
	readline? ( sys-libs/readline:0= )
	pcre? ( dev-libs/libpcre2 )
	!net-ftp/netkit-tftp
	!net-ftp/tftp-hpa
	!net-ftp/uftpd
	selinux? ( sec-policy/selinux-tftp )
	
"
DEPEND="${RDEPEND}
"

post_src_unpack() {
	mv madmartin-atftp-* ${S}
}


src_prepare() {
	append-cppflags -D_REENTRANT -DRATE_CONTROL
	# restore pre-GCC5 inline semantics, as the tree ebuild did
	append-cflags -std=gnu89
	default
	eautoreconf
}

src_configure() {
	econf \
	  $(use_enable tcpd libwrap) \
	  $(use_enable readline libreadline) \
	  $(use_enable pcre libpcre) \
	  --enable-mtftp
}

src_install() {
	default
	 if use systemd ; then
	  systemd_dounit "${FILESDIR}"/atftp.service
	  systemd_install_serviced "${FILESDIR}"/atftp.service.conf
	else
	  newinitd "${FILESDIR}"/atftp.init atftp
	  newconfd "${FILESDIR}"/atftp.confd atftp
	fi
	 dodoc README* BUGS FAQ Changelog INSTALL TODO
	if [ -d docs ] ; then
	  dodoc docs/*
	fi
}



# vim: filetype=ebuild
