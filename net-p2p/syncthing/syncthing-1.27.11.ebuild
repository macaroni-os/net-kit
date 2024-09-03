# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop go-module user xdg-utils

EGO_SUM=(
	"github.com/!audrius!butkevicius/recli v0.0.7-0.20220911121932-d000ce8fbf0f"
	"github.com/!audrius!butkevicius/recli v0.0.7-0.20220911121932-d000ce8fbf0f/go.mod"
	"github.com/!azure/go-ntlmssp v0.0.0-20221128193559-754e69321358"
	"github.com/!azure/go-ntlmssp v0.0.0-20221128193559-754e69321358/go.mod"
	"github.com/!burnt!sushi/toml v1.3.2/go.mod"
	"github.com/alecthomas/assert/v2 v2.6.0"
	"github.com/alecthomas/assert/v2 v2.6.0/go.mod"
	"github.com/alecthomas/kong v0.9.0"
	"github.com/alecthomas/kong v0.9.0/go.mod"
	"github.com/alecthomas/repr v0.4.0"
	"github.com/alecthomas/repr v0.4.0/go.mod"
	"github.com/alexbrainman/sspi v0.0.0-20231016080023-1a75b4708caa"
	"github.com/alexbrainman/sspi v0.0.0-20231016080023-1a75b4708caa/go.mod"
	"github.com/beorn7/perks v1.0.1"
	"github.com/beorn7/perks v1.0.1/go.mod"
	"github.com/calmh/glob v0.0.0-20220615080505-1d823af5017b"
	"github.com/calmh/glob v0.0.0-20220615080505-1d823af5017b/go.mod"
	"github.com/calmh/incontainer v1.0.0"
	"github.com/calmh/incontainer v1.0.0/go.mod"
	"github.com/calmh/xdr v1.1.0"
	"github.com/calmh/xdr v1.1.0/go.mod"
	"github.com/ccding/go-stun v0.1.5"
	"github.com/ccding/go-stun v0.1.5/go.mod"
	"github.com/cenkalti/backoff/v4 v4.3.0"
	"github.com/cenkalti/backoff/v4 v4.3.0/go.mod"
	"github.com/certifi/gocertifi v0.0.0-20210507211836-431795d63e8d"
	"github.com/certifi/gocertifi v0.0.0-20210507211836-431795d63e8d/go.mod"
	"github.com/cespare/xxhash/v2 v2.3.0"
	"github.com/cespare/xxhash/v2 v2.3.0/go.mod"
	"github.com/chmduquesne/rollinghash v4.0.0+incompatible"
	"github.com/chmduquesne/rollinghash v4.0.0+incompatible/go.mod"
	"github.com/chzyer/logex v1.1.10/go.mod"
	"github.com/chzyer/readline v0.0.0-20180603132655-2972be24d48e/go.mod"
	"github.com/chzyer/test v0.0.0-20180213035817-a1ea475d72b1/go.mod"
	"github.com/cpuguy83/go-md2man/v2 v2.0.4"
	"github.com/cpuguy83/go-md2man/v2 v2.0.4/go.mod"
	"github.com/d4l3k/messagediff v1.2.1"
	"github.com/d4l3k/messagediff v1.2.1/go.mod"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/davecgh/go-spew v1.1.1/go.mod"
	"github.com/fsnotify/fsnotify v1.4.7/go.mod"
	"github.com/fsnotify/fsnotify v1.4.9/go.mod"
	"github.com/fsnotify/fsnotify v1.5.4/go.mod"
	"github.com/fsnotify/fsnotify v1.6.0/go.mod"
	"github.com/fsnotify/fsnotify v1.7.0"
	"github.com/fsnotify/fsnotify v1.7.0/go.mod"
	"github.com/getsentry/raven-go v0.2.0"
	"github.com/getsentry/raven-go v0.2.0/go.mod"
	"github.com/go-asn1-ber/asn1-ber v1.5.5/go.mod"
	"github.com/go-asn1-ber/asn1-ber v1.5.7"
	"github.com/go-asn1-ber/asn1-ber v1.5.7/go.mod"
	"github.com/go-ldap/ldap/v3 v3.4.8"
	"github.com/go-ldap/ldap/v3 v3.4.8/go.mod"
	"github.com/go-logr/logr v1.4.2"
	"github.com/go-logr/logr v1.4.2/go.mod"
	"github.com/go-ole/go-ole v1.2.6/go.mod"
	"github.com/go-ole/go-ole v1.3.0"
	"github.com/go-ole/go-ole v1.3.0/go.mod"
	"github.com/go-task/slim-sprig v0.0.0-20210107165309-348f09dbbbc0/go.mod"
	"github.com/go-task/slim-sprig/v3 v3.0.0"
	"github.com/go-task/slim-sprig/v3 v3.0.0/go.mod"
	"github.com/gofrs/flock v0.12.1"
	"github.com/gofrs/flock v0.12.1/go.mod"
	"github.com/gogo/protobuf v1.3.2"
	"github.com/gogo/protobuf v1.3.2/go.mod"
	"github.com/golang/protobuf v1.2.0/go.mod"
	"github.com/golang/protobuf v1.4.0-rc.1/go.mod"
	"github.com/golang/protobuf v1.4.0-rc.1.0.20200221234624-67d41d38c208/go.mod"
	"github.com/golang/protobuf v1.4.0-rc.2/go.mod"
	"github.com/golang/protobuf v1.4.0-rc.4.0.20200313231945-b860323f09d0/go.mod"
	"github.com/golang/protobuf v1.4.0/go.mod"
	"github.com/golang/protobuf v1.4.2/go.mod"
	"github.com/golang/protobuf v1.5.0/go.mod"
	"github.com/golang/protobuf v1.5.2/go.mod"
	"github.com/golang/snappy v0.0.4"
	"github.com/golang/snappy v0.0.4/go.mod"
	"github.com/google/go-cmp v0.3.0/go.mod"
	"github.com/google/go-cmp v0.3.1/go.mod"
	"github.com/google/go-cmp v0.4.0/go.mod"
	"github.com/google/go-cmp v0.5.5/go.mod"
	"github.com/google/go-cmp v0.5.6/go.mod"
	"github.com/google/go-cmp v0.5.7/go.mod"
	"github.com/google/go-cmp v0.6.0"
	"github.com/google/go-cmp v0.6.0/go.mod"
	"github.com/google/pprof v0.0.0-20210407192527-94a9f03dee38/go.mod"
	"github.com/google/pprof v0.0.0-20240727154555-813a5fbdbec8"
	"github.com/google/pprof v0.0.0-20240727154555-813a5fbdbec8/go.mod"
	"github.com/google/uuid v1.6.0"
	"github.com/google/uuid v1.6.0/go.mod"
	"github.com/gorilla/securecookie v1.1.1/go.mod"
	"github.com/gorilla/sessions v1.2.1/go.mod"
	"github.com/greatroar/blobloom v0.8.0"
	"github.com/greatroar/blobloom v0.8.0/go.mod"
	"github.com/hashicorp/errwrap v1.0.0/go.mod"
	"github.com/hashicorp/errwrap v1.1.0"
	"github.com/hashicorp/errwrap v1.1.0/go.mod"
	"github.com/hashicorp/go-multierror v1.0.0/go.mod"
	"github.com/hashicorp/go-multierror v1.1.1"
	"github.com/hashicorp/go-multierror v1.1.1/go.mod"
	"github.com/hashicorp/go-uuid v1.0.2/go.mod"
	"github.com/hashicorp/go-uuid v1.0.3"
	"github.com/hashicorp/go-uuid v1.0.3/go.mod"
	"github.com/hashicorp/golang-lru/v2 v2.0.7"
	"github.com/hashicorp/golang-lru/v2 v2.0.7/go.mod"
	"github.com/hexops/gotextdiff v1.0.3"
	"github.com/hexops/gotextdiff v1.0.3/go.mod"
	"github.com/hpcloud/tail v1.0.0/go.mod"
	"github.com/ianlancetaylor/demangle v0.0.0-20200824232613-28f6c0f3b639/go.mod"
	"github.com/jackpal/gateway v1.0.15"
	"github.com/jackpal/gateway v1.0.15/go.mod"
	"github.com/jackpal/go-nat-pmp v1.0.2"
	"github.com/jackpal/go-nat-pmp v1.0.2/go.mod"
	"github.com/jcmturner/aescts/v2 v2.0.0"
	"github.com/jcmturner/aescts/v2 v2.0.0/go.mod"
	"github.com/jcmturner/dnsutils/v2 v2.0.0"
	"github.com/jcmturner/dnsutils/v2 v2.0.0/go.mod"
	"github.com/jcmturner/gofork v1.7.6"
	"github.com/jcmturner/gofork v1.7.6/go.mod"
	"github.com/jcmturner/goidentity/v6 v6.0.1"
	"github.com/jcmturner/goidentity/v6 v6.0.1/go.mod"
	"github.com/jcmturner/gokrb5/v8 v8.4.4"
	"github.com/jcmturner/gokrb5/v8 v8.4.4/go.mod"
	"github.com/jcmturner/rpc/v2 v2.0.3"
	"github.com/jcmturner/rpc/v2 v2.0.3/go.mod"
	"github.com/julienschmidt/httprouter v1.3.0"
	"github.com/julienschmidt/httprouter v1.3.0/go.mod"
	"github.com/kballard/go-shellquote v0.0.0-20180428030007-95032a82bc51"
	"github.com/kballard/go-shellquote v0.0.0-20180428030007-95032a82bc51/go.mod"
	"github.com/kisielk/errcheck v1.5.0/go.mod"
	"github.com/kisielk/gotool v1.0.0/go.mod"
	"github.com/kr/pretty v0.3.1"
	"github.com/kr/pretty v0.3.1/go.mod"
	"github.com/kr/text v0.2.0"
	"github.com/kr/text v0.2.0/go.mod"
	"github.com/lib/pq v1.10.9"
	"github.com/lib/pq v1.10.9/go.mod"
	"github.com/lufia/plan9stats v0.0.0-20211012122336-39d0f177ccd0"
	"github.com/lufia/plan9stats v0.0.0-20211012122336-39d0f177ccd0/go.mod"
	"github.com/maruel/panicparse/v2 v2.3.1"
	"github.com/maruel/panicparse/v2 v2.3.1/go.mod"
	"github.com/mattn/go-colorable v0.1.12/go.mod"
	"github.com/mattn/go-isatty v0.0.14/go.mod"
	"github.com/maxbrunsfeld/counterfeiter/v6 v6.8.1"
	"github.com/maxbrunsfeld/counterfeiter/v6 v6.8.1/go.mod"
	"github.com/maxmind/geoipupdate/v6 v6.1.0"
	"github.com/maxmind/geoipupdate/v6 v6.1.0/go.mod"
	"github.com/mgutz/ansi v0.0.0-20200706080929-d51e80ef957d/go.mod"
	"github.com/miscreant/miscreant.go v0.0.0-20200214223636-26d376326b75"
	"github.com/miscreant/miscreant.go v0.0.0-20200214223636-26d376326b75/go.mod"
	"github.com/munnerz/goautoneg v0.0.0-20191010083416-a7dc8b61c822"
	"github.com/munnerz/goautoneg v0.0.0-20191010083416-a7dc8b61c822/go.mod"
	"github.com/nxadm/tail v1.4.4/go.mod"
	"github.com/nxadm/tail v1.4.8/go.mod"
	"github.com/nxadm/tail v1.4.11"
	"github.com/nxadm/tail v1.4.11/go.mod"
	"github.com/onsi/ginkgo v1.6.0/go.mod"
	"github.com/onsi/ginkgo v1.12.1/go.mod"
	"github.com/onsi/ginkgo v1.16.4/go.mod"
	"github.com/onsi/ginkgo v1.16.5"
	"github.com/onsi/ginkgo v1.16.5/go.mod"
	"github.com/onsi/ginkgo/v2 v2.1.3/go.mod"
	"github.com/onsi/ginkgo/v2 v2.20.0"
	"github.com/onsi/ginkgo/v2 v2.20.0/go.mod"
	"github.com/onsi/gomega v1.7.1/go.mod"
	"github.com/onsi/gomega v1.10.1/go.mod"
	"github.com/onsi/gomega v1.17.0/go.mod"
	"github.com/onsi/gomega v1.19.0/go.mod"
	"github.com/onsi/gomega v1.34.1"
	"github.com/onsi/gomega v1.34.1/go.mod"
	"github.com/oschwald/geoip2-golang v1.11.0"
	"github.com/oschwald/geoip2-golang v1.11.0/go.mod"
	"github.com/oschwald/maxminddb-golang v1.13.1"
	"github.com/oschwald/maxminddb-golang v1.13.1/go.mod"
	"github.com/pierrec/lz4/v4 v4.1.21"
	"github.com/pierrec/lz4/v4 v4.1.21/go.mod"
	"github.com/pkg/errors v0.8.1/go.mod"
	"github.com/pkg/errors v0.9.1"
	"github.com/pkg/errors v0.9.1/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/posener/complete v1.2.3"
	"github.com/posener/complete v1.2.3/go.mod"
	"github.com/power-devops/perfstat v0.0.0-20240221224432-82ca36839d55"
	"github.com/power-devops/perfstat v0.0.0-20240221224432-82ca36839d55/go.mod"
	"github.com/prashantv/gostub v1.1.0"
	"github.com/prashantv/gostub v1.1.0/go.mod"
	"github.com/prometheus/client_golang v1.19.1"
	"github.com/prometheus/client_golang v1.19.1/go.mod"
	"github.com/prometheus/client_model v0.6.1"
	"github.com/prometheus/client_model v0.6.1/go.mod"
	"github.com/prometheus/common v0.55.0"
	"github.com/prometheus/common v0.55.0/go.mod"
	"github.com/prometheus/procfs v0.15.1"
	"github.com/prometheus/procfs v0.15.1/go.mod"
	"github.com/quic-go/quic-go v0.46.0"
	"github.com/quic-go/quic-go v0.46.0/go.mod"
	"github.com/rabbitmq/amqp091-go v1.10.0"
	"github.com/rabbitmq/amqp091-go v1.10.0/go.mod"
	"github.com/rcrowley/go-metrics v0.0.0-20201227073835-cf1acfcdf475"
	"github.com/rcrowley/go-metrics v0.0.0-20201227073835-cf1acfcdf475/go.mod"
	"github.com/riywo/loginshell v0.0.0-20200815045211-7d26008be1ab"
	"github.com/riywo/loginshell v0.0.0-20200815045211-7d26008be1ab/go.mod"
	"github.com/rogpeppe/go-internal v1.10.0"
	"github.com/rogpeppe/go-internal v1.10.0/go.mod"
	"github.com/russross/blackfriday/v2 v2.1.0"
	"github.com/russross/blackfriday/v2 v2.1.0/go.mod"
	"github.com/sclevine/spec v1.4.0"
	"github.com/sclevine/spec v1.4.0/go.mod"
	"github.com/shirou/gopsutil/v4 v4.24.7"
	"github.com/shirou/gopsutil/v4 v4.24.7/go.mod"
	"github.com/shoenig/go-m1cpu v0.1.6"
	"github.com/shoenig/go-m1cpu v0.1.6/go.mod"
	"github.com/shoenig/test v0.6.4"
	"github.com/shoenig/test v0.6.4/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/objx v0.4.0/go.mod"
	"github.com/stretchr/objx v0.5.0/go.mod"
	"github.com/stretchr/objx v0.5.2"
	"github.com/stretchr/objx v0.5.2/go.mod"
	"github.com/stretchr/testify v1.4.0/go.mod"
	"github.com/stretchr/testify v1.5.1/go.mod"
	"github.com/stretchr/testify v1.7.1/go.mod"
	"github.com/stretchr/testify v1.7.2/go.mod"
	"github.com/stretchr/testify v1.8.0/go.mod"
	"github.com/stretchr/testify v1.8.1/go.mod"
	"github.com/stretchr/testify v1.8.4/go.mod"
	"github.com/stretchr/testify v1.9.0"
	"github.com/stretchr/testify v1.9.0/go.mod"
	"github.com/syncthing/notify v0.0.0-20210616190510-c6b7342338d2"
	"github.com/syncthing/notify v0.0.0-20210616190510-c6b7342338d2/go.mod"
	"github.com/syndtr/goleveldb v1.0.1-0.20220721030215-126854af5e6d"
	"github.com/syndtr/goleveldb v1.0.1-0.20220721030215-126854af5e6d/go.mod"
	"github.com/thejerf/suture/v4 v4.0.5"
	"github.com/thejerf/suture/v4 v4.0.5/go.mod"
	"github.com/tklauser/go-sysconf v0.3.12"
	"github.com/tklauser/go-sysconf v0.3.12/go.mod"
	"github.com/tklauser/numcpus v0.6.1"
	"github.com/tklauser/numcpus v0.6.1/go.mod"
	"github.com/urfave/cli v1.20.0/go.mod"
	"github.com/urfave/cli v1.22.15"
	"github.com/urfave/cli v1.22.15/go.mod"
	"github.com/vitrun/qart v0.0.0-20160531060029-bf64b92db6b0"
	"github.com/vitrun/qart v0.0.0-20160531060029-bf64b92db6b0/go.mod"
	"github.com/willabides/kongplete v0.4.0"
	"github.com/willabides/kongplete v0.4.0/go.mod"
	"github.com/yuin/goldmark v1.1.27/go.mod"
	"github.com/yuin/goldmark v1.2.1/go.mod"
	"github.com/yuin/goldmark v1.4.13/go.mod"
	"github.com/yusufpapurcu/wmi v1.2.4"
	"github.com/yusufpapurcu/wmi v1.2.4/go.mod"
	"go.uber.org/automaxprocs v1.5.3"
	"go.uber.org/automaxprocs v1.5.3/go.mod"
	"go.uber.org/goleak v1.3.0"
	"go.uber.org/goleak v1.3.0/go.mod"
	"go.uber.org/mock v0.4.0"
	"go.uber.org/mock v0.4.0/go.mod"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/crypto v0.0.0-20191011191535-87dc89f01550/go.mod"
	"golang.org/x/crypto v0.0.0-20200622213623-75b288015ac9/go.mod"
	"golang.org/x/crypto v0.0.0-20210921155107-089bfa567519/go.mod"
	"golang.org/x/crypto v0.6.0/go.mod"
	"golang.org/x/crypto v0.19.0/go.mod"
	"golang.org/x/crypto v0.21.0/go.mod"
	"golang.org/x/crypto v0.26.0"
	"golang.org/x/crypto v0.26.0/go.mod"
	"golang.org/x/exp v0.0.0-20240808152545-0cdaa3abc0fa"
	"golang.org/x/exp v0.0.0-20240808152545-0cdaa3abc0fa/go.mod"
	"golang.org/x/mod v0.2.0/go.mod"
	"golang.org/x/mod v0.3.0/go.mod"
	"golang.org/x/mod v0.6.0-dev.0.20220419223038-86c51ed26bb4/go.mod"
	"golang.org/x/mod v0.8.0/go.mod"
	"golang.org/x/mod v0.20.0"
	"golang.org/x/mod v0.20.0/go.mod"
	"golang.org/x/net v0.0.0-20180906233101-161cd47e91fd/go.mod"
	"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
	"golang.org/x/net v0.0.0-20190620200207-3b0461eec859/go.mod"
	"golang.org/x/net v0.0.0-20200114155413-6afb5195e5aa/go.mod"
	"golang.org/x/net v0.0.0-20200226121028-0de0cce0169b/go.mod"
	"golang.org/x/net v0.0.0-20200520004742-59133d7f0dd7/go.mod"
	"golang.org/x/net v0.0.0-20201021035429-f5854403a974/go.mod"
	"golang.org/x/net v0.0.0-20210226172049-e18ecbb05110/go.mod"
	"golang.org/x/net v0.0.0-20210428140749-89ef3d95e781/go.mod"
	"golang.org/x/net v0.0.0-20220225172249-27dd8689420f/go.mod"
	"golang.org/x/net v0.0.0-20220607020251-c690dde0001d/go.mod"
	"golang.org/x/net v0.0.0-20220722155237-a158d28d115b/go.mod"
	"golang.org/x/net v0.6.0/go.mod"
	"golang.org/x/net v0.7.0/go.mod"
	"golang.org/x/net v0.10.0/go.mod"
	"golang.org/x/net v0.21.0/go.mod"
	"golang.org/x/net v0.22.0/go.mod"
	"golang.org/x/net v0.28.0"
	"golang.org/x/net v0.28.0/go.mod"
	"golang.org/x/sync v0.0.0-20180314180146-1d60e4601c6f/go.mod"
	"golang.org/x/sync v0.0.0-20190423024810-112230192c58/go.mod"
	"golang.org/x/sync v0.0.0-20190911185100-cd5d95a43a6e/go.mod"
	"golang.org/x/sync v0.0.0-20201020160332-67f06af15bc9/go.mod"
	"golang.org/x/sync v0.0.0-20220722155255-886fb9371eb4/go.mod"
	"golang.org/x/sync v0.1.0/go.mod"
	"golang.org/x/sync v0.8.0"
	"golang.org/x/sync v0.8.0/go.mod"
	"golang.org/x/sys v0.0.0-20180909124046-d0be0721c37e/go.mod"
	"golang.org/x/sys v0.0.0-20180926160741-c2ed4eda69e7/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
	"golang.org/x/sys v0.0.0-20190904154756-749cb33beabd/go.mod"
	"golang.org/x/sys v0.0.0-20190916202348-b4ddaad3f8a3/go.mod"
	"golang.org/x/sys v0.0.0-20191005200804-aed5e4c7ecf9/go.mod"
	"golang.org/x/sys v0.0.0-20191120155948-bd437916bb0e/go.mod"
	"golang.org/x/sys v0.0.0-20191204072324-ce4227a45e2e/go.mod"
	"golang.org/x/sys v0.0.0-20200323222414-85ca7c5b95cd/go.mod"
	"golang.org/x/sys v0.0.0-20200930185726-fdedc70b468f/go.mod"
	"golang.org/x/sys v0.0.0-20201119102817-f84b799fce68/go.mod"
	"golang.org/x/sys v0.0.0-20201204225414-ed752295db88/go.mod"
	"golang.org/x/sys v0.0.0-20210112080510-489259a85091/go.mod"
	"golang.org/x/sys v0.0.0-20210423082822-04245dca01da/go.mod"
	"golang.org/x/sys v0.0.0-20210615035016-665e8c7367d1/go.mod"
	"golang.org/x/sys v0.0.0-20210630005230-0f9fa26af87c/go.mod"
	"golang.org/x/sys v0.0.0-20210927094055-39ccf1dd6fa6/go.mod"
	"golang.org/x/sys v0.0.0-20211216021012-1d35b9e2eb4e/go.mod"
	"golang.org/x/sys v0.0.0-20220408201424-a24fb2fb8a0f/go.mod"
	"golang.org/x/sys v0.0.0-20220412211240-33da011f77ad/go.mod"
	"golang.org/x/sys v0.0.0-20220520151302-bc2c85ada10a/go.mod"
	"golang.org/x/sys v0.0.0-20220722155257-8c9f86f7a55f/go.mod"
	"golang.org/x/sys v0.0.0-20220908164124-27713097b956/go.mod"
	"golang.org/x/sys v0.1.0/go.mod"
	"golang.org/x/sys v0.5.0/go.mod"
	"golang.org/x/sys v0.8.0/go.mod"
	"golang.org/x/sys v0.11.0/go.mod"
	"golang.org/x/sys v0.17.0/go.mod"
	"golang.org/x/sys v0.18.0/go.mod"
	"golang.org/x/sys v0.24.0"
	"golang.org/x/sys v0.24.0/go.mod"
	"golang.org/x/term v0.0.0-20201126162022-7de9c90e9dd1/go.mod"
	"golang.org/x/term v0.0.0-20210927222741-03fcf44c2211/go.mod"
	"golang.org/x/term v0.5.0/go.mod"
	"golang.org/x/term v0.8.0/go.mod"
	"golang.org/x/term v0.17.0/go.mod"
	"golang.org/x/term v0.18.0/go.mod"
	"golang.org/x/text v0.3.0/go.mod"
	"golang.org/x/text v0.3.3/go.mod"
	"golang.org/x/text v0.3.6/go.mod"
	"golang.org/x/text v0.3.7/go.mod"
	"golang.org/x/text v0.7.0/go.mod"
	"golang.org/x/text v0.9.0/go.mod"
	"golang.org/x/text v0.14.0/go.mod"
	"golang.org/x/text v0.17.0"
	"golang.org/x/text v0.17.0/go.mod"
	"golang.org/x/time v0.6.0"
	"golang.org/x/time v0.6.0/go.mod"
	"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
	"golang.org/x/tools v0.0.0-20191119224855-298f0cb1881e/go.mod"
	"golang.org/x/tools v0.0.0-20200619180055-7c47624df98f/go.mod"
	"golang.org/x/tools v0.0.0-20201224043029-2b0845dc783e/go.mod"
	"golang.org/x/tools v0.0.0-20210106214847-113979e3529a/go.mod"
	"golang.org/x/tools v0.1.12/go.mod"
	"golang.org/x/tools v0.6.0/go.mod"
	"golang.org/x/tools v0.24.0"
	"golang.org/x/tools v0.24.0/go.mod"
	"golang.org/x/xerrors v0.0.0-20190717185122-a985d3407aa7/go.mod"
	"golang.org/x/xerrors v0.0.0-20191011141410-1b5146add898/go.mod"
	"golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543/go.mod"
	"golang.org/x/xerrors v0.0.0-20200804184101-5ec99f83aff1/go.mod"
	"golang.org/x/xerrors v0.0.0-20220517211312-f3a8303e98df/go.mod"
	"google.golang.org/protobuf v0.0.0-20200109180630-ec00e32a8dfd/go.mod"
	"google.golang.org/protobuf v0.0.0-20200221191635-4d8936d0db64/go.mod"
	"google.golang.org/protobuf v0.0.0-20200228230310-ab0ca4ff8a60/go.mod"
	"google.golang.org/protobuf v1.20.1-0.20200309200217-e05f789c0967/go.mod"
	"google.golang.org/protobuf v1.21.0/go.mod"
	"google.golang.org/protobuf v1.23.0/go.mod"
	"google.golang.org/protobuf v1.26.0-rc.1/go.mod"
	"google.golang.org/protobuf v1.26.0/go.mod"
	"google.golang.org/protobuf v1.34.2"
	"google.golang.org/protobuf v1.34.2/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/check.v1 v1.0.0-20201130134442-10cb98267c6c"
	"gopkg.in/check.v1 v1.0.0-20201130134442-10cb98267c6c/go.mod"
	"gopkg.in/fsnotify.v1 v1.4.7/go.mod"
	"gopkg.in/tomb.v1 v1.0.0-20141024135613-dd632973f1e7"
	"gopkg.in/tomb.v1 v1.0.0-20141024135613-dd632973f1e7/go.mod"
	"gopkg.in/yaml.v2 v2.2.2/go.mod"
	"gopkg.in/yaml.v2 v2.2.4/go.mod"
	"gopkg.in/yaml.v2 v2.3.0/go.mod"
	"gopkg.in/yaml.v2 v2.4.0/go.mod"
	"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c/go.mod"
	"gopkg.in/yaml.v3 v3.0.1"
	"gopkg.in/yaml.v3 v3.0.1/go.mod"
)

go-module_set_globals

DESCRIPTION="Open Source Continuous File Synchronization"
HOMEPAGE="https://github.com/syncthing/syncthing"
SRC_URI="https://github.com/syncthing/syncthing/tarball/4d3b0a5dfdd24553ced0e09ceac2fe8c5b0d715f -> syncthing-1.27.11-4d3b0a5.tar.gz
https://distfiles.macaronios.org/8c/82/2a/8c822a90057c85a03e1065ff6ea32494c3339b9d5ad478532d8ae679da5a9e6753583ab2e52176dcc1675c4bd9752e8ffaffa08d2566f14178979fa237da97b0 -> syncthing-1.27.11-funtoo-go-bundle-9580a4acbec995c4d2efe87092a623528f121d2424c460075262907db9a9833b2b462868b778cbd7e63e878bfaeb1c0ed871b2597a6e48d041246e0980937932.tar.gz"

LICENSE="Apache-2.0 BSD BSD-2 ISC MIT MPL-2.0 Unlicense"
SLOT="0"
KEYWORDS="*"
IUSE="tools"
S="${WORKDIR}/syncthing-syncthing-4d3b0a5"

DEPEND=">=dev-lang/go-1.17"

DOCS=( README.md AUTHORS CONTRIBUTING.md )

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} ${PN}

	if use tools ; then
		# separate user for the discovery server
		enewgroup stdiscosrv
		enewuser stdiscosrv -1 -1 /var/lib/stdiscosrv stdiscosrv
		keepdir /var/lib/stdiscosrv
		fowners stdiscosrv:stdiscosrv /var/lib/stdiscosrv

		# separate user for the relay server
		enewgroup strelaysrv
		enewuser strelaysrv -1 -1 /var/lib/strelaysrv strelaysrv
		# and his home folder
		keepdir /var/lib/strelaysrv
		fowners strelaysrv:strelaysrv /var/lib/strelaysrv
	fi
}

src_prepare() {
	# Bug #679280
	xdg_environment_reset

	default

	# We do not need this and it sometimes causes build failures
	rm -rf cmd/stupgrades
}

src_compile() {
	GOARCH= go run build.go -version "v${PV}" -no-upgrade -build-out=bin/ \
		${GOARCH:+-goarch="${GOARCH}"} \
		build $(usex tools "all" "") || die "build failed"
}

src_test() {
	go run build.go test || die "test failed"
}

src_install() {
	local icon_size

	doman man/*.[157]
	einstalldocs

	dobin bin/syncthing

	domenu etc/linux-desktop/*.desktop
	for icon_size in 32 64 128 256 512; do
		newicon -s ${icon_size} assets/logo-${icon_size}.png ${PN}.png
	done
	newicon -s scalable assets/logo-only.svg ${PN}.svg

	if use tools; then
		exeinto /usr/libexec/syncthing
		local exe
		for exe in bin/* ; do
			[[ "${exe}" == "bin/syncthing" ]] || doexe "${exe}"
		done
	fi

	# openrc service files
	newconfd "${FILESDIR}/${PN}.confd" ${PN}
	newinitd "${FILESDIR}/${PN}.initd" ${PN}

	keepdir /var/{lib,log}/${PN}
	fowners ${PN}:${PN} /var/{lib,log}/${PN}
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotate" ${PN}

	if use tools ; then
		# openrc service files

		newconfd "${FILESDIR}/stdiscosrv.confd" stdiscosrv
		newinitd "${FILESDIR}/stdiscosrv.initd" stdiscosrv

		newconfd "${FILESDIR}/strelaysrv.confd" strelaysrv
		newinitd "${FILESDIR}/strelaysrv.initd" strelaysrv

		insinto /etc/logrotate.d
		newins "${FILESDIR}/stdiscosrv.logrotate" strelaysrv
		newins "${FILESDIR}/strelaysrv.logrotate" strelaysrv
	fi
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}