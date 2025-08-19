# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
inherit autotools toolchain-funcs flag-o-matic

DESCRIPTION="Controls Ethernet frame filtering on a Linux bridge, MAC NAT and brouting"
HOMEPAGE="http://ebtables.sourceforge.net/"
SRC_URI="https://www.netfilter.org/pub/ebtables/ebtables-2.0.11.tar.gz -> ebtables-2.0.11.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
DOCS=(
	ChangeLog
	THANKS
)
IUSE="+perl static"
RDEPEND="perl? ( dev-lang/perl )
	net-misc/ethertypes
	
"
DEPEND="${RDEPEND}
"
src_configure() {
	econf \
	  --bindir="/bin" \
	  --sbindir="/sbin" \
	  --libdir="/$(get_libdir)/ebtables" \
	  $(use_enable static)
}
src_install() {
	if ! use static; then
	  emake DESTDIR="${D}" install
	  if ! use perl; then
	    rm "${ED}"/sbin/ebtables-save || die
	  fi
	  rm "${ED%/}"/etc/ethertypes || die
	else
	  into /
	  newsbin static ebtables
	fi
	keepdir /var/lib/ebtables/
	newinitd "${FILESDIR}"/ebtables.initd-r1 ebtables
	newconfd "${FILESDIR}"/ebtables.confd-r1 ebtables
	einstalldocs
}


# vim: filetype=ebuild
