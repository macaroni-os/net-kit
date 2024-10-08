# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools systemd tmpfiles

DESCRIPTION="Provides a daemon for managing internet connections"
HOMEPAGE="https://01.org/connman"
SRC_URI="mirror://kernel/linux/network/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

IUSE="${IUSE} bluetooth debug doc examples +ethernet iptables iwd l2tp nftables"
IUSE="${IUSE} ofono openvpn openconnect pptp policykit tools vpnc +wifi wispr networkmanager"

REQUIRED_USE="|| ( iptables nftables )"
RDEPEND=">=dev-libs/glib-2.16
	>=sys-apps/dbus-1.2.24
	sys-libs/readline:0=
	iptables? ( >=net-firewall/iptables-1.4.8 )
	bluetooth? ( net-wireless/bluez )
	iwd? ( net-wireless/iwd )
	l2tp? ( net-dialup/xl2tpd )
	nftables? (
		>=net-libs/libnftnl-1.0.4:0=
		>=net-libs/libmnl-1.0.0:0= )
	ofono? ( net-misc/ofono )
	openconnect? ( net-vpn/openconnect )
	openvpn? ( net-vpn/openvpn )
	policykit? ( sys-auth/polkit )
	pptp? ( net-dialup/pptpclient )
	vpnc? ( net-vpn/vpnc )
	wifi? ( >=net-wireless/wpa_supplicant-2.0[dbus] )
	wispr? ( net-libs/gnutls )"

DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-2.6.39
	virtual/pkgconfig"


src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--localstatedir=/var \
		--with-systemdunitdir=$(systemd_get_systemunitdir) \
		--with-tmpfilesdir="${EPREFIX}"/usr/lib/tmpfiles.d \
		--enable-client \
		--enable-datafiles \
		--enable-loopback=builtin \
		$(use_enable examples test) \
		$(use_enable ethernet ethernet builtin) \
		$(use_enable wifi wifi builtin) \
		$(use_enable iwd) \
		$(use_enable bluetooth bluetooth builtin) \
		$(use_enable l2tp l2tp builtin) \
		$(use_enable ofono ofono builtin) \
		$(use_enable openconnect openconnect builtin) \
		$(use_enable openvpn openvpn builtin) \
		$(use_enable policykit polkit builtin) \
		$(use_enable pptp pptp builtin) \
		$(use_enable vpnc vpnc builtin) \
		$(use_enable wispr wispr builtin) \
		$(use_enable debug) \
		$(use_enable tools) \
		$(use_enable networkmanager nmcompat) \
		--with-firewall=$(usex iptables "iptables" "nftables" ) \
		--disable-iospm \
		--disable-hh2serial-gps
}

src_install() {
	default
	dobin client/connmanctl

	if use doc; then
		dodoc doc/*.txt
	fi
	keepdir /usr/lib/${PN}/scripts
	keepdir /var/lib/${PN}
	newinitd "${FILESDIR}"/${PN}.initd2 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}

pkg_postinst() {
	tmpfiles_process /usr/lib/tmpfiles.d/connman_resolvconf.conf
}
