# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

EGO_SUM=(
	"github.com/!adhitya!ramadhanus/fasthttpcors v0.0.0-20170121111917-d4c07198763a"
	"github.com/!adhitya!ramadhanus/fasthttpcors v0.0.0-20170121111917-d4c07198763a/go.mod"
	"github.com/alecthomas/units v0.0.0-20240927000941-0f3dac36c52b"
	"github.com/alecthomas/units v0.0.0-20240927000941-0f3dac36c52b/go.mod"
	"github.com/andybalholm/brotli v1.1.1"
	"github.com/andybalholm/brotli v1.1.1/go.mod"
	"github.com/beorn7/perks v1.0.1"
	"github.com/beorn7/perks v1.0.1/go.mod"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/davecgh/go-spew v1.1.1/go.mod"
	"github.com/go-echarts/go-echarts/v2 v2.4.5"
	"github.com/go-echarts/go-echarts/v2 v2.4.5/go.mod"
	"github.com/klauspost/compress v1.17.11"
	"github.com/klauspost/compress v1.17.11/go.mod"
	"github.com/kr/pretty v0.2.1"
	"github.com/kr/pretty v0.2.1/go.mod"
	"github.com/kr/pty v1.1.1/go.mod"
	"github.com/kr/text v0.1.0"
	"github.com/kr/text v0.1.0/go.mod"
	"github.com/mattn/go-isatty v0.0.20"
	"github.com/mattn/go-isatty v0.0.20/go.mod"
	"github.com/mattn/go-runewidth v0.0.16"
	"github.com/mattn/go-runewidth v0.0.16/go.mod"
	"github.com/nicksnyder/go-i18n v1.10.3"
	"github.com/nicksnyder/go-i18n v1.10.3/go.mod"
	"github.com/pelletier/go-toml v1.2.0/go.mod"
	"github.com/pelletier/go-toml v1.9.5"
	"github.com/pelletier/go-toml v1.9.5/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/prashantv/gostub v1.1.0"
	"github.com/prashantv/gostub v1.1.0/go.mod"
	"github.com/rivo/uniseg v0.2.0/go.mod"
	"github.com/rivo/uniseg v0.4.7"
	"github.com/rivo/uniseg v0.4.7/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/objx v0.4.0/go.mod"
	"github.com/stretchr/objx v0.5.0/go.mod"
	"github.com/stretchr/objx v0.5.2/go.mod"
	"github.com/stretchr/testify v1.7.1/go.mod"
	"github.com/stretchr/testify v1.8.0/go.mod"
	"github.com/stretchr/testify v1.8.4/go.mod"
	"github.com/stretchr/testify v1.9.0"
	"github.com/stretchr/testify v1.9.0/go.mod"
	"github.com/valyala/bytebufferpool v1.0.0"
	"github.com/valyala/bytebufferpool v1.0.0/go.mod"
	"github.com/valyala/fasthttp v1.57.0"
	"github.com/valyala/fasthttp v1.57.0/go.mod"
	"github.com/xyproto/randomstring v1.0.5"
	"github.com/xyproto/randomstring v1.0.5/go.mod"
	"go.uber.org/automaxprocs v1.6.0"
	"go.uber.org/automaxprocs v1.6.0/go.mod"
	"golang.org/x/net v0.31.0"
	"golang.org/x/net v0.31.0/go.mod"
	"golang.org/x/sys v0.6.0/go.mod"
	"golang.org/x/sys v0.27.0"
	"golang.org/x/sys v0.27.0/go.mod"
	"golang.org/x/text v0.20.0"
	"golang.org/x/text v0.20.0/go.mod"
	"golang.org/x/time v0.8.0"
	"golang.org/x/time v0.8.0/go.mod"
	"gopkg.in/alecthomas/kingpin.v3-unstable v3.0.0-20191105091915-95d230a53780"
	"gopkg.in/alecthomas/kingpin.v3-unstable v3.0.0-20191105091915-95d230a53780/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/check.v1 v1.0.0-20201130134442-10cb98267c6c"
	"gopkg.in/check.v1 v1.0.0-20201130134442-10cb98267c6c/go.mod"
	"gopkg.in/yaml.v2 v2.2.1/go.mod"
	"gopkg.in/yaml.v2 v2.4.0"
	"gopkg.in/yaml.v2 v2.4.0/go.mod"
	"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c/go.mod"
	"gopkg.in/yaml.v3 v3.0.1"
	"gopkg.in/yaml.v3 v3.0.1/go.mod"
)

go-module_set_globals

DESCRIPTION="HTTP(S) benchmarking tool, written in Golang"
HOMEPAGE="https://github.com/six-ddc/plow"
SRC_URI="https://github.com/six-ddc/plow/tarball/205533b7956f3aa615fc07c29e8e25bd2f34a704 -> plow-1.3.2-205533b.tar.gz
https://distfiles.macaronios.org/01/ef/92/01ef92605b389340584f097b368b70b8b74bc5471a320bce03c8e5b22c422d3bed5d1e0d711783beee486820322fe6f43a530ab1730e385f66c0f67915351160 -> plow-1.3.2-funtoo-go-bundle-3415fa623bde0c27a38e67c15a7caab14eddc4a4363a5d3a672b00e37dc097513e45755747ff5a480dd280d237059d6b57274477b78aec9267455b710ece188b.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"

post_src_unpack() {
	mv ${WORKDIR}/six-ddc-plow-* ${S} || die
}

src_compile() {
	go build -mod=mod . || die "compile failed"
}

src_install() {
	dobin ${PN}
	dodoc README.md
}