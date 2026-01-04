# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
PYTHON_COMPAT=( python3+ )
inherit python-any-r1 systemd user

DESCRIPTION="A Web Service Discovery host daemon."
HOMEPAGE="https://github.com/christgau/wsdd"
SRC_URI="https://api.github.com/repos/christgau/wsdd/tarball/v0.9 -> wsdd-0.9-e9325b5.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE="samba systemd"
RDEPEND="${PYTHON_DEPS}
	samba? ( net-fs/samba )
	
"

post_src_unpack() {
	mv christgau-wsdd-* ${S}
}


pkg_setup() {
	enewgroup wsdd
	enewuser wsdd -1 -1 -1 wsdd
	python-any-r1_pkg_setup
}
src_install() {
	python_newscript src/wsdd.py wsdd
	 doconfd etc/openrc/conf.d/wsdd
	 if use systemd ; then
	  # install systemd unit file with dependency on samba service if use flag is set
	  if use samba; then
	    sed -i -e 's/;Wants=smb.service/Wants=samba.service/' etc/systemd/wsdd.service
	  fi
	  systemd_dounit etc/systemd/wsdd.service
	else
	  # remove dependency on samba from init.d script if samba is not in use flags
	  if ! use samba ; then
	    sed -i -e '/need samba/d' etc/openrc/init.d/wsdd
	  fi
	  sed -i -e "s/daemon:daemon/${PN}:${PN}/" etc/openrc/init.d/wsdd
	   doinitd etc/openrc/init.d/wsdd
	fi
	 dodoc README.md
	doman man/wsdd.8
}



# vim: filetype=ebuild
