# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
PYTHON_COMPAT=( python3+ )
inherit meson python-any-r1 toolchain-funcs udev user vala systemd

DESCRIPTION="A set of co-operative tools that make networking simple and straightforward"
HOMEPAGE="https://wiki.gnome.org/Projects/NetworkManager"
SRC_URI="https://gitlab.freedesktop.org/NetworkManager/NetworkManager/-/archive/1.58.0/networkmanager-1.58.0.tar.bz2 -> networkmanager-1.58.0.tar.bz2"
LICENSE="GPL-2+ LGPL-2.1"
SLOT="0"
KEYWORDS="*"
IUSE="audit bluetooth +concheck connection-sharing debug dhclient dhcpcd
elogind gnutls +gtk-doc +introspection iptables iwd psl libedit lto
+nss nftables +modemmanager ofono ovs policykit +ppp resolvconf syslog
systemd teamd +tools +vala +wext +wifi
"
# Commons depends
CDEPEND="sys-apps/util-linux
	elogind? ( sys-auth/elogind )
	virtual/libudev:=
	sys-apps/dbus
	net-libs/libndp
	dev-libs/glib:2
	introspection? ( dev-libs/gobject-introspection:= )
	audit? ( sys-process/audit )
	teamd? (
	  dev-libs/jansson:=
	  net-misc/libteam
	)
	policykit? ( sys-auth/polkit )
	nss? ( dev-libs/nss:= )
	gnutls? (
	  net-libs/gnutls:=
	)
	ppp? ( net-dialup/ppp:=[ipv6] )
	modemmanager? (
	  net-misc/mobile-broadband-provider-info
	  net-misc/modemmanager:=
	)
	bluetooth? ( net-wireless/bluez )
	ofono? ( net-misc/ofono )
	dhclient? ( net-misc/dhcp[client] )
	dhcpcd? ( net-misc/dhcpcd )
	ovs? ( dev-libs/jansson:= )
	resolvconf? ( virtual/resolvconf )
	connection-sharing? (
	  net-dns/dnsmasq[dbus,dhcp]
	  iptables? ( net-firewall/iptables )
	  nftables? ( net-firewall/nftables )
	)
	psl? ( net-libs/libpsl )
	concheck? ( net-misc/curl )
	tools? (
	  dev-libs/newt
	  libedit? ( dev-libs/libedit )
	  !libedit? ( sys-libs/readline:= )
	)
	
"
BDEPEND="dev-util/gdbus-codegen
	gtk-doc? (
	  dev-util/gtk-doc
	  app-text/docbook-xml-dtd:4.1.2
	)
	dev-util/intltool
	sys-devel/gettext
	introspection? (
	  $(python_gen_any_dep 'dev-python/pygobject:3[${PYTHON_USEDEP}]')
	  dev-lang/perl
	  dev-libs/libxslt
	)
	vala? ( $(vala_depend) )
	
"
RDEPEND="${CDEPEND}
	|| (
	  net-misc/iputils[arping(+)]
	  net-analyzer/arping
	)
	wifi? (
	  !iwd? ( net-wireless/wpa_supplicant[dbus] )
	  iwd? ( net-wireless/iwd )
	)
	
"
DEPEND="${CDEPEND}
	sys-kernel/linux-headers
	net-libs/libndp
	dev-libs/jansson
	
"
S="${WORKDIR}/NetworkManager-1.58.0"
post_src_unpack() {
	mv NetworkManager-* "${S}"
}
pkg_setup() {
	enewgroup plugdev
	if use introspection; then
	  python-any-r1_pkg_setup
	fi
}
src_prepare() {
	default
	use vala && vala_src_prepare
	sed -i \
	  -e 's#/usr/bin/sed#/bin/sed#' \
	  data/84-nm-drivers.rules \
	  || die
}
meson_nm_program() {
	usex "$1" "-D${2:-$1}=$3" "-D${2:-$1}=no"
}
src_configure() {
	local emesonargs=(
	  --localstatedir="${EPREFIX}/var"
	   -Dsystem_ca_path=/etc/ssl/certs
	  -Dudev_dir=$(get_udevdir)
	  -Ddbus_conf_dir=/usr/share/dbus-1/system.d
	  -Dkernel_firmware_dir=/lib/firmware
	  -Diptables=/sbin/iptables
	  -Dnft=/sbin/nft
	  -Ddnsmasq=/usr/sbin/dnsmasq
	   -Ddist_version=${PVR}
	  $(meson_use policykit polkit)
	  $(meson_use policykit config_auth_polkit_default)
	  -Dmodify_system=true
	  -Dpolkit_agent_helper_1=/usr/lib/polkit-1/polkit-agent-helper-1
	  -Dselinux=false
	  # TODO: check if we can customize this for macaroni
	  -Dhostname_persist=gentoo
	  -Dlibaudit=$(usex audit)
	   $(meson_use wext)
	  $(meson_use wifi)
	  $(meson_use iwd)
	  $(meson_use ppp)
	  -Dpppd=/usr/sbin/pppd
	  $(meson_use modemmanager modem_manager)
	  $(meson_use ofono)
	  $(meson_use concheck)
	  $(meson_use teamd teamdctl)
	  $(meson_use ovs)
	  $(meson_use tools nmcli)
	  $(meson_use tools nmtui)
	  $(meson_use tools nm_cloud_setup)
	  $(meson_use bluetooth bluez5_dun)
	  -Debpf=true
	   -Dconfig_wifi_backend_default=$(usex iwd iwd default)
	  -Dconfig_plugins_default=keyfile
	  -Difcfg_rh=false
	  -Difupdown=false
	   $(meson_nm_program resolvconf "" /sbin/resolvconf)
	  -Dnetconfig=no
	  -Dconfig_dns_rc_manager_default=auto
	   $(meson_nm_program dhclient "" /sbin/dhclient)
	  $(meson_nm_program dhcpcd "" /sbin/dhcpcd)
	   $(meson_use introspection)
	  $(meson_use vala vapi)
	  $(meson_use gtk-doc docs)
	  -Dtests=no
	  -Dfirewalld_zone=true
	  -Dmore_asserts=0
	  $(meson_use debug more_logging)
	  -Dvalgrind=no
	  -Dvalgrind_suppressions=
	  -Dld_gc=false
	  $(meson_use psl libpsl)
	  -Dqt=false
	  # For now disable NVME Boot firmware Table
	  -Dnbft=false
	   -Dsession_tracking_consolekit=false
	  $(meson_use lto b_lto)
	  -Dsystemdsystemunitdir=$(systemd_get_systemunitdir)
	)
	 if use elogind; then
	  emesonargs+=(
	    -Dsession_tracking=elogind
	    -Dsuspend_resume=elogind
	    -Dsystemd_journal=false
	  )
	else
	  if use systemd; then
	    emesonargs+=(
	      -Dsuspend_resume=systemd
	      -Dsession_tracking=systemd
	      -Dsystemd_journal=true
	    )
	  else
	    emesonargs+=(
	      -Dsession_tracking=no
	      -Dsystemd_journal=false
	    )
	  fi
	fi
	 if use syslog; then
	  emesonargs+=( -Dconfig_logging_backend_default=syslog )
	else
	  emesonargs+=( -Dconfig_logging_backend_default=default )
	fi
	 if use dhclient; then
	  emesonargs+=( -Dconfig_dhcp_default=dhclient )
	elif use dhcpcd; then
	  emesonargs+=( -Dconfig_dhcp_default=dhcpcd )
	else
	  emesonargs+=( -Dconfig_dhcp_default=internal )
	fi
	 if use nss; then
	  emesonargs+=( -Dcrypto=nss )
	else
	  emesonargs+=( -Dcrypto=gnutls )
	fi
	 if use tools ; then
	  emesonargs+=( -Dreadline=$(usex libedit libedit libreadline) )
	else
	  emesonargs+=( -Dreadline=none )
	fi
	 # Same hack as net-dialup/pptpd to get proper plugin dir for ppp, bug #519986
	if use ppp; then
	  local PPPD_VER=`best_version net-dialup/ppp`
	  PPPD_VER=${PPPD_VER#*/*-} #reduce it to ${PV}-${PR}
	  PPPD_VER=${PPPD_VER%%[_-]*} # main version without beta/pre/patch/revision
	  emesonargs+=( -Dpppd_plugin_dir=/usr/$(get_libdir)/pppd/${PPPD_VER} )
	fi
	 meson_src_configure
}
src_install() {
	meson_src_install
	 newinitd "${FILESDIR}/init.d.NetworkManager-r2" NetworkManager
	newconfd "${FILESDIR}/conf.d.NetworkManager" NetworkManager
	 # Need to keep the /etc/NetworkManager/dispatched.d for dispatcher scripts
	keepdir /etc/NetworkManager/dispatcher.d
	 # Provide openrc net dependency only when nm is connected
	exeinto /etc/NetworkManager/dispatcher.d
	newexe "${FILESDIR}/10-openrc-status-r4" 10-openrc-status
	sed -e "s:@EPREFIX@:${EPREFIX}:g" \
	  -i "${ED}/etc/NetworkManager/dispatcher.d/10-openrc-status" || die
	 keepdir /etc/NetworkManager/system-connections
	chmod 0600 "${ED}"/etc/NetworkManager/system-connections/.keep* 
	 # Allow users in plugdev group to modify system connections
	insinto /usr/share/polkit-1/rules.d/
	doins "${FILESDIR}"/01-org.freedesktop.NetworkManager.settings.modify.system.rules
	 insinto /usr/lib/NetworkManager/conf.d #702476
	doins "${S}"/examples/nm-conf.d/31-mac-addr-change.conf
	 if use iwd; then
	  # This goes to $nmlibdir/conf.d/ and $nmlibdir is
	  # '${prefix}'/lib/$PACKAGE, thus always lib, not get_libdir
	  local f="${ED}"/usr/lib/NetworkManager/conf.d/iwd.conf
	  echo "[device]" > ${f}
	  echo "wifi.backend=iwd" >> ${f}
	fi
	 mv "${ED}"/usr/share/doc/{NetworkManager/examples/,${PF}} || die
	rmdir "${ED}"/usr/share/doc/NetworkManager || die
	 # Empty
	rmdir "${ED}"/var{/lib{/NetworkManager,},} || die
	 if ! use systemd ; then
	  einfo "Removing systemd files ..."
	  rm -vrf "${ED}"/lib/systemd || die
	fi
}


# vim: filetype=ebuild
