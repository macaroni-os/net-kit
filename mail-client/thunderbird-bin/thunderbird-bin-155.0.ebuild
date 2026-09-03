# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
MOZ_PN="thunderbird"
MOZ_PV="${PV}"
MOZ_P="${MOZ_PN}-${MOZ_PV}"
QA_PREBUILT="
  opt/thunderbird/*.so
  opt/thunderbird/${PN}
  opt/thunderbird/crashreporter
  opt/thunderbird/pingsender
  opt/thunderbird/plugin-container
  opt/thunderbird/minidump-analyzer
  opt/thunderbird/mozilla-xremote-client
  opt/thunderbird/updater
"

inherit eutils pax-utils xdg-utils desktop

DESCRIPTION="Thunderbird Mail Client"
HOMEPAGE="https://www.thunderbird.net/"
SRC_URI="
amd64? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/en-US/thunderbird-155.0.tar.xz -> thunderbird-bin-155.0.tar.xz )
l10n_af? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/af.xpi -> thunderbird-bin-155.0-af.xpi )
l10n_ar? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/ar.xpi -> thunderbird-bin-155.0-ar.xpi )
l10n_ast? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/ast.xpi -> thunderbird-bin-155.0-ast.xpi )
l10n_be? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/be.xpi -> thunderbird-bin-155.0-be.xpi )
l10n_bg? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/bg.xpi -> thunderbird-bin-155.0-bg.xpi )
l10n_br? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/br.xpi -> thunderbird-bin-155.0-br.xpi )
l10n_ca? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/ca.xpi -> thunderbird-bin-155.0-ca.xpi )
l10n_cak? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/cak.xpi -> thunderbird-bin-155.0-cak.xpi )
l10n_cs? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/cs.xpi -> thunderbird-bin-155.0-cs.xpi )
l10n_cy? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/cy.xpi -> thunderbird-bin-155.0-cy.xpi )
l10n_da? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/da.xpi -> thunderbird-bin-155.0-da.xpi )
l10n_de? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/de.xpi -> thunderbird-bin-155.0-de.xpi )
l10n_dsb? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/dsb.xpi -> thunderbird-bin-155.0-dsb.xpi )
l10n_el? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/el.xpi -> thunderbird-bin-155.0-el.xpi )
l10n_en-CA? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/en-CA.xpi -> thunderbird-bin-155.0-en-CA.xpi )
l10n_en-GB? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/en-GB.xpi -> thunderbird-bin-155.0-en-GB.xpi )
l10n_en-US? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/en-US.xpi -> thunderbird-bin-155.0-en-US.xpi )
l10n_es-AR? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/es-AR.xpi -> thunderbird-bin-155.0-es-AR.xpi )
l10n_es-ES? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/es-ES.xpi -> thunderbird-bin-155.0-es-ES.xpi )
l10n_es-MX? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/es-MX.xpi -> thunderbird-bin-155.0-es-MX.xpi )
l10n_et? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/et.xpi -> thunderbird-bin-155.0-et.xpi )
l10n_eu? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/eu.xpi -> thunderbird-bin-155.0-eu.xpi )
l10n_fi? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/fi.xpi -> thunderbird-bin-155.0-fi.xpi )
l10n_fr? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/fr.xpi -> thunderbird-bin-155.0-fr.xpi )
l10n_fy-NL? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/fy-NL.xpi -> thunderbird-bin-155.0-fy-NL.xpi )
l10n_ga-IE? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/ga-IE.xpi -> thunderbird-bin-155.0-ga-IE.xpi )
l10n_gd? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/gd.xpi -> thunderbird-bin-155.0-gd.xpi )
l10n_gl? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/gl.xpi -> thunderbird-bin-155.0-gl.xpi )
l10n_he? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/he.xpi -> thunderbird-bin-155.0-he.xpi )
l10n_hr? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/hr.xpi -> thunderbird-bin-155.0-hr.xpi )
l10n_hsb? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/hsb.xpi -> thunderbird-bin-155.0-hsb.xpi )
l10n_hu? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/hu.xpi -> thunderbird-bin-155.0-hu.xpi )
l10n_hy-AM? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/hy-AM.xpi -> thunderbird-bin-155.0-hy-AM.xpi )
l10n_id? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/id.xpi -> thunderbird-bin-155.0-id.xpi )
l10n_is? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/is.xpi -> thunderbird-bin-155.0-is.xpi )
l10n_it? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/it.xpi -> thunderbird-bin-155.0-it.xpi )
l10n_ja? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/ja.xpi -> thunderbird-bin-155.0-ja.xpi )
l10n_ka? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/ka.xpi -> thunderbird-bin-155.0-ka.xpi )
l10n_kab? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/kab.xpi -> thunderbird-bin-155.0-kab.xpi )
l10n_kk? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/kk.xpi -> thunderbird-bin-155.0-kk.xpi )
l10n_ko? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/ko.xpi -> thunderbird-bin-155.0-ko.xpi )
l10n_lt? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/lt.xpi -> thunderbird-bin-155.0-lt.xpi )
l10n_lv? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/lv.xpi -> thunderbird-bin-155.0-lv.xpi )
l10n_ms? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/ms.xpi -> thunderbird-bin-155.0-ms.xpi )
l10n_nb-NO? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/nb-NO.xpi -> thunderbird-bin-155.0-nb-NO.xpi )
l10n_nl? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/nl.xpi -> thunderbird-bin-155.0-nl.xpi )
l10n_nn-NO? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/nn-NO.xpi -> thunderbird-bin-155.0-nn-NO.xpi )
l10n_pa-IN? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/pa-IN.xpi -> thunderbird-bin-155.0-pa-IN.xpi )
l10n_pl? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/pl.xpi -> thunderbird-bin-155.0-pl.xpi )
l10n_pt-BR? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/pt-BR.xpi -> thunderbird-bin-155.0-pt-BR.xpi )
l10n_pt-PT? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/pt-PT.xpi -> thunderbird-bin-155.0-pt-PT.xpi )
l10n_rm? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/rm.xpi -> thunderbird-bin-155.0-rm.xpi )
l10n_ro? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/ro.xpi -> thunderbird-bin-155.0-ro.xpi )
l10n_ru? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/ru.xpi -> thunderbird-bin-155.0-ru.xpi )
l10n_sk? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/sk.xpi -> thunderbird-bin-155.0-sk.xpi )
l10n_sl? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/sl.xpi -> thunderbird-bin-155.0-sl.xpi )
l10n_sq? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/sq.xpi -> thunderbird-bin-155.0-sq.xpi )
l10n_sr? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/sr.xpi -> thunderbird-bin-155.0-sr.xpi )
l10n_sv-SE? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/sv-SE.xpi -> thunderbird-bin-155.0-sv-SE.xpi )
l10n_th? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/th.xpi -> thunderbird-bin-155.0-th.xpi )
l10n_tr? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/tr.xpi -> thunderbird-bin-155.0-tr.xpi )
l10n_uk? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/uk.xpi -> thunderbird-bin-155.0-uk.xpi )
l10n_uz? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/uz.xpi -> thunderbird-bin-155.0-uz.xpi )
l10n_vi? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/vi.xpi -> thunderbird-bin-155.0-vi.xpi )
l10n_zh-CN? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/zh-CN.xpi -> thunderbird-bin-155.0-zh-CN.xpi )
l10n_zh-TW? ( https://archive.mozilla.org/pub/thunderbird/releases/155.0/linux-x86_64/xpi/zh-TW.xpi -> thunderbird-bin-155.0-zh-TW.xpi )"
LICENSE="MPL-2.0 GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="*"
IUSE="amd64 +crashreporter +ffmpeg +pulseaudio selinux
l10n_af l10n_ar l10n_ast l10n_be l10n_bg l10n_br l10n_ca l10n_cak l10n_cs
l10n_cy l10n_da l10n_de l10n_dsb l10n_el l10n_en-CA l10n_en-GB l10n_en-US
l10n_es-AR l10n_es-ES l10n_es-MX l10n_et l10n_eu l10n_fi l10n_fr l10n_fy-NL
l10n_ga-IE l10n_gd l10n_gl l10n_he l10n_hr l10n_hsb l10n_hu l10n_hy-AM l10n_id
l10n_is l10n_it l10n_ja l10n_ka l10n_kab l10n_kk l10n_ko l10n_lt l10n_lv
l10n_ms l10n_nb-NO l10n_nl l10n_nn-NO l10n_pa-IN l10n_pl l10n_pt-BR
l10n_pt-PT l10n_rm l10n_ro l10n_ru l10n_sk l10n_sl l10n_sq l10n_sr l10n_sv-SE
l10n_th l10n_tr l10n_uk l10n_uz l10n_vi l10n_zh-CN l10n_zh-TW
"
RESTRICT="strip"
BDEPEND="!mail-client/thunderbird-esr-bin
	
"
RDEPEND="dev-libs/atk
	sys-apps/dbus
	dev-libs/dbus-glib
	dev-libs/glib
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	virtual/freedesktop-icon-theme
	x11-libs/cairo[X]
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender
	x11-libs/libXt
	x11-libs/pango
	pulseaudio? ( media-sound/pulseaudio )
	ffmpeg? ( media-video/ffmpeg )
	crashreporter? ( net-misc/curl )
	!mail-client/thunderbird-esr-bin
	
"
DEPEND="app-arch/unzip
	app-arch/zip
	
"
S="${WORKDIR}/thunderbird"
src_unpack() {
	einfo "${A}"
	local _lp_dir="${WORKDIR}/language_packs"
	local _src_file

	if [[ ! -d "${_lp_dir}" ]] ; then
		mkdir "${_lp_dir}" || die
	fi

	for _src_file in ${A} ; do
		if [[ ${_src_file} == *.xpi ]]; then
			cp "${DISTDIR}/${_src_file}" "${_lp_dir}" || die "Failed to copy '${_src_file}' to '${_lp_dir}'!"
		else
			unpack ${_src_file}
		fi
	done
}
moz_install_xpi() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${#} -lt 2 ]] ; then
		die "${FUNCNAME} requires at least two arguments"
	fi

	local DESTDIR=${1}
	shift

	insinto "${DESTDIR}"

	local emid xpi_file xpi_tmp_dir
	for xpi_file in "${@}" ; do
		emid=
		xpi_tmp_dir=$(mktemp -d --tmpdir="${T}")
		# Unpack XPI
		unzip -qq "${xpi_file}" -d "${xpi_tmp_dir}" || die
		# Determine extension ID
		if [[ -f "${xpi_tmp_dir}/install.rdf" ]] ; then
			emid=$(
				sed -n -e '/install-manifest/,$ { /em:id/!d; s/.*[\">]\([^\"<>]*\)[\"<].*/\1/; p; q }' \
				"${xpi_tmp_dir}/install.rdf")
			[[ -z "${emid}" ]] && die "failed to determine extension id from install.rdf"
		elif [[ -f "${xpi_tmp_dir}/manifest.json" ]] ; then
			emid=$(sed -n -e 's/.*"id": "\([^"]*\)".*/\1/p' "${xpi_tmp_dir}/manifest.json")
			[[ -z "${emid}" ]] && die "failed to determine extension id from manifest.json"
		else
			die "failed to determine extension id"
		fi

		einfo "Installing ${emid}.xpi into ${ED}/${DESTDIR} ..."
		newins "${xpi_file}" "${emid}.xpi"
	done
}
src_install() {
	local MOZILLA_FIVE_HOME="/opt/thunderbird"
	local PLUGIN_BASE_PATH="/usr/$(get_libdir)"

	local size sizes icon_path icon name
	sizes="16 22 24 32 48 128"
	icon_path="${S}/chrome/icons/default"
	icon="thunderbird-bin-icon"
	name="Thunderbird"

	# Install icons and .desktop for menu entry
	for size in ${sizes}; do
		insinto "/usr/share/icons/hicolor/${size}x${size}/apps"
		newins "${icon_path}/default${size}.png" "${icon}.png"
	done
	# Install a 48x48 icon into /usr/share/pixmaps for legacy DEs
	newicon "${S}"/chrome/icons/default/default48.png "${icon}.png"
	domenu "${FILESDIR}"/icon/thunderbird-bin.desktop

	# Install thunderbird in /opt
	dodir ${MOZILLA_FIVE_HOME%/*}
	mv "${S}" "${ED}"${MOZILLA_FIVE_HOME}
	cd "${WORKDIR}" || die # PWD no longer exists so move to somewhere that does

	# Install language packs
	local langpacks=( $(find "${WORKDIR}/language_packs" -type f -name '*.xpi') )
	if [[ -n "${langpacks}" ]] ; then
		moz_install_xpi "${MOZILLA_FIVE_HOME}/distribution/extensions" "${langpacks[@]}"
	fi

	# Create /usr/bin/thunderbird-bin
	newbin - thunderbird-bin <<- _EOF_
		#!/bin/sh
		exec ${MOZILLA_FIVE_HOME}/thunderbird "\$@"
	_EOF_

	# revdep-rebuild entry
	insinto /etc/revdep-rebuild
	doins "${FILESDIR}"/10thunderbird-bin

	# Enable very specific settings for thunderbird
	insinto ${MOZILLA_FIVE_HOME}/defaults/pref/
	newins "${FILESDIR}"/thunderbird-macaroni-default-prefs.js all-macaroni.js

	# Plugins dir
	dosym "${PLUGIN_BASE_PATH}/nsbrowser/plugins" "${MOZILLA_FIVE_HOME}/plugins"

	pax-mark mr "${ED}"${MOZILLA_FIVE_HOME}/{thunderbird-bin,thunderbird,plugin-container}
}
pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	use ffmpeg || ewarn "USE=-ffmpeg : HTML5 video will not render without media-video/ffmpeg installed"
	use pulseaudio || ewarn "USE=-pulseaudio : audio will not play without pulseaudio installed"
}
pkg_postrm() {
	xdg_icon_cache_update
}


# vim: filetype=ebuild
