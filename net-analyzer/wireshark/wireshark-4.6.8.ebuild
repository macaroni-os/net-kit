# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
PYTHON_COMPAT=( python3+ )
inherit fcaps python-any-r1 user xdg cmake

DESCRIPTION="Network protocol analyzer (sniffer)"
HOMEPAGE="https://www.wireshark.org/"
SRC_URI="https://www.wireshark.org/download/src/all-versions/wireshark-4.6.8.tar.xz -> wireshark-4.6.8.tar.xz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
PATCHES=(
	"${FILESDIR}/4.4.6-lto.patch"
	"${FILESDIR}/4.6.2-gnutls-pkcs11.patch"
)
IUSE="androiddump brotli +capinfos +captype ciscodump +dftest doc dpauxmon +dumpcap +editcap +gui http2 kerberos lto lua lz4 maxminddb +mergecap +minizip +netlink opus pkcs11 +plugins +pcap +randpkt +randpktdump +reordercap sbc +sharkd snappy sshdump ssl +text2pcap +tshark +udpdump wifi xxhash zlib +zstd"
REQUIRED_USE="pkcs11? ( ssl )"
BDEPEND="${PYTHON_DEPS}
	dev-lang/perl
	sys-devel/flex
	sys-devel/gettext
	virtual/pkgconfig
	doc? (
	  app-doc/doxygen
	  app-text/asciidoctor
	  dev-libs/libxslt
	)
	gui? (
	  dev-qt/qttools:6[linguist]
	)
"
RDEPEND=">=dev-libs/glib-2.50.0:2
	dev-libs/libpcre2:=
	dev-libs/libxml2:=
	>=dev-libs/libgcrypt-1.8.0:=
	>=net-dns/c-ares-1.13.0:=
	media-libs/speexdsp
	brotli? ( app-arch/brotli:= )
	ciscodump? ( >=net-libs/libssh-0.6:= )
	filecaps? ( sys-libs/libcap )
	gui? (
	  dev-qt/qtbase:6[gui]
	  dev-qt/qt5compat:6
	  dev-qt/qtmultimedia:6
	  virtual/freedesktop-icon-theme
	  x11-misc/xdg-utils
	)
	http2? ( >=net-libs/nghttp2-1.11.0:= )
	kerberos? ( virtual/krb5 )
	lua? ( dev-lua/lua:5.3 )
	lz4? ( app-arch/lz4:= )
	maxminddb? ( dev-libs/libmaxminddb:= )
	minizip? ( sys-libs/zlib[minizip] )
	netlink? ( dev-libs/libnl:3 )
	opus? ( media-libs/opus )
	pcap? ( net-libs/libpcap )
	sbc? ( media-libs/sbc )
	snappy? ( app-arch/snappy:= )
	sshdump? ( >=net-libs/libssh-0.6:= )
	ssl? ( >=net-libs/gnutls-3.5.8:=[pkcs11?] )
	wifi? ( >=net-libs/libssh-0.6:= )
	xxhash? ( dev-libs/xxhash )
	zlib? ( sys-libs/zlib )
	zstd? ( app-arch/zstd:= )
"
DEPEND="${RDEPEND}
"
pkg_setup() {
	python-any-r1_pkg_setup
	enewgroup pcap
}
src_prepare() {
	if use lua; then
		sed -i "s/set(LUA_VERSIONS5 5.5 5.4 5.3 5.2 5.1 5.0)/set(LUA_VERSIONS5 5.3)/g" \
			cmake/modules/FindLua.cmake || die
	fi
	cmake_src_prepare
}
src_configure() {
	local mycmakeargs
	python_setup
	mycmakeargs+=(
		-DPython3_EXECUTABLE="${PYTHON}"
		-DCMAKE_DISABLE_FIND_PACKAGE_{Asciidoctor,DOXYGEN}=$(usex !doc)
		-DLEMON_EXECUTABLE=
		-DRPMBUILD_EXECUTABLE=
		-DGIT_EXECUTABLE=
		-DENABLE_CCACHE=OFF
		$(use androiddump && use pcap && echo -DEXTCAP_ANDROIDDUMP_LIBPCAP=yes)
		-DBUILD_androiddump=$(usex androiddump)
		-DBUILD_capinfos=$(usex capinfos)
		-DBUILD_captype=$(usex captype)
		-DBUILD_ciscodump=$(usex ciscodump)
		-DBUILD_dftest=$(usex dftest)
		-DBUILD_dpauxmon=$(usex dpauxmon)
		-DBUILD_dumpcap=$(usex dumpcap)
		-DBUILD_editcap=$(usex editcap)
		-DBUILD_mergecap=$(usex mergecap)
		-DBUILD_mmdbresolve=$(usex maxminddb)
		-DBUILD_randpkt=$(usex randpkt)
		-DBUILD_randpktdump=$(usex randpktdump)
		-DBUILD_reordercap=$(usex reordercap)
		-DBUILD_sdjournal=OFF
		-DBUILD_sharkd=$(usex sharkd)
		-DBUILD_sshdump=$(usex sshdump)
		-DBUILD_text2pcap=$(usex text2pcap)
		-DBUILD_tfshark=OFF
		-DBUILD_tshark=$(usex tshark)
		-DBUILD_udpdump=$(usex udpdump)
		-DBUILD_wifidump=$(usex wifi)
		-DBUILD_wireshark=$(usex gui)
		-DUSE_qt6=$(usex gui)
		-DENABLE_WERROR=OFF
		-DENABLE_BCG729=OFF
		-DENABLE_BROTLI=$(usex brotli)
		-DENABLE_CAP=$(usex filecaps caps)
		-DENABLE_GNUTLS=$(usex ssl)
		-DENABLE_ILBC=OFF
		-DENABLE_KERBEROS=$(usex kerberos)
		-DENABLE_LTO=$(usex lto)
		-DENABLE_LUA=$(usex lua)
		-DENABLE_LZ4=$(usex lz4)
		-DENABLE_MINIZIP=$(usex minizip)
		-DENABLE_MINIZIPNG=OFF
		-DENABLE_NETLINK=$(usex netlink)
		-DENABLE_NGHTTP2=$(usex http2)
		-DENABLE_NGHTTP3=OFF
		-DENABLE_OPUS=$(usex opus)
		-DENABLE_PCAP=$(usex pcap)
		-DENABLE_PKCS11=$(usex pkcs11)
		-DENABLE_PLUGINS=$(usex plugins)
		-DENABLE_PLUGIN_IFDEMO=OFF
		-DENABLE_SBC=$(usex sbc)
		-DENABLE_SMI=OFF
		-DENABLE_SNAPPY=$(usex snappy)
		-DENABLE_SPANDSP=OFF
		-DENABLE_XXHASH=$(usex xxhash)
		-DENABLE_ZLIB=$(usex zlib)
		-DENABLE_ZLIBNG=OFF
		-DENABLE_ZSTD=$(usex zstd)
	)
	cmake_src_configure
}
src_install() {
	cmake_src_install install-headers

	dodoc AUTHORS ChangeLog README* doc/randpkt.txt doc/README*

	insinto /usr/include/wireshark
	doins "${BUILD_DIR}"/config.h

	local dir dirs=(
		epan
		epan/crypt
		epan/dfilter
		epan/dissectors
		epan/ftypes
		wiretap
		wsutil
		wsutil/wmem
	)

	for dir in "${dirs[@]}" ; do
		insinto /usr/include/wireshark/${dir}
		doins ${dir}/*.h
	done

	if use gui ; then
		local s

		for s in 16 32 48 64 128 256 512 1024 ; do
			insinto /usr/share/icons/hicolor/${s}x${s}/apps
			newins resources/icons/wsicon${s}.png wireshark.png
		done

		for s in 16 24 32 48 64 128 256 ; do
			insinto /usr/share/icons/hicolor/${s}x${s}/mimetypes
			newins resources/icons/WiresharkDoc-${s}.png application-vnd.tcpdump.pcap.png
		done
	fi

	if [[ -d "${ED}"/usr/share/appdata ]] ; then
		rm -r "${ED}"/usr/share/appdata || die
	fi
}
pkg_postinst() {
	xdg_pkg_postinst

	if use dumpcap && use pcap; then
		# Add group for users allowed to sniff.
		chgrp pcap "${EROOT}"/usr/bin/dumpcap || die

		fcaps -o 0 -g pcap -m 4710 -M 0710 \
			cap_dac_read_search,cap_net_raw,cap_net_admin \
			"${EROOT}"/usr/bin/dumpcap
	fi

	ewarn "NOTE: To capture traffic with wireshark as normal user you have to"
	ewarn "add yourself to the pcap group. This security measure ensures"
	ewarn "that only trusted users are allowed to sniff your traffic."
}

# vim: filetype=ebuild
