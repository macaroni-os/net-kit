# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
inherit autotools toolchain-funcs

DESCRIPTION="An easy to use text-based based mail and news client"
HOMEPAGE="https://alpineapp.email/alpine/index.html"
SRC_URI="https://alpineapp.email/alpine/patches/alpine-2.26/alpine-2.26.tar.xz -> alpine-2.26.tar.xz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="ipv6 kerberos ldap passfile nls smime ssl"
RDEPEND="app-misc/mime-types
	sys-libs/ncurses
	kerberos? ( app-crypt/mit-krb5 )
	ldap? ( net-nds/openldap )
	ssl? ( dev-libs/openssl )
"
DEPEND="${RDEPEND}
"
src_configure() {
	myconf=(
	  --without-tcl
	  --with-pthread
	  --with-system-pinerc="${EPREFIX}"/etc/pine.conf
	  --with-system-fixed-pinerc="${EPREFIX}"/etc/pine.conf.fixed
	  $(use_with ldap)
	  $(use_with ssl)
	  $(use_with passfile passfile .pinepwd)
	  $(use_with kerberos krb5)
	  $(use_enable nls)
	  $(use_with ipv6)
	  $(use_with smime)
	)
	 if has_version "app-text/hunspell"; then
	  myconf+=( --with-interactive-spellcheck=/usr/bin/hunspell )
	elif has_version "app-text/aspell"; then
	  myconf+=( --with-interactive-spellcheck=/usr/bin/aspell )
	fi
	 if use ssl; then
	  myconf+=(
	    --with-ssl-include-dir="${EPREFIX}"/usr/include/openssl
	    --with-ssl-lib-dir="${EPREFIX}"/usr/$(get_libdir)
	    --with-ssl-certs-dir="${EPREFIX}"/etc/ssl/certs
	  )
	fi
	  # Gentoo Bug 935343; see imap/docs/bugs.txt
	if use ipv6; then
	  sed -i "s/IP=4/IP=6/" imap/Makefile || die
	fi
	 # dial down warnings about unused results
	append-flags -Wno-unused-result
	 econf "${myconf[@]}"
}


# vim: filetype=ebuild
