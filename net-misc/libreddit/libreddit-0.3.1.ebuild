# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
aead-0.3.2
aes-0.6.0
aes-gcm-0.8.0
aes-soft-0.6.4
aesni-0.10.0
aho-corasick-0.7.15
anyhow-1.0.38
arrayvec-0.5.2
askama-0.10.5
askama_derive-0.10.5
askama_escape-0.10.1
askama_shared-0.11.1
async-attributes-1.1.2
async-channel-1.6.1
async-dup-1.2.2
async-executor-1.4.0
async-global-executor-2.0.2
async-h1-2.3.1
async-io-1.3.1
async-lock-2.3.0
async-mutex-1.4.0
async-process-1.0.2
async-recursion-0.3.2
async-sse-4.1.0
async-std-1.9.0
async-task-4.0.3
async-trait-0.1.42
atomic-waker-1.0.0
autocfg-1.0.1
base-x-0.2.8
base64-0.13.0
bitflags-1.2.1
bitvec-0.19.4
block-buffer-0.9.0
blocking-1.0.2
bumpalo-3.6.1
byte-pool-0.2.2
bytes-0.5.6
bytes-1.0.1
cache-padded-1.1.1
cached-0.23.0
cached_proc_macro-0.6.0
cached_proc_macro_types-0.1.0
cc-1.0.67
cfg-if-0.1.10
cfg-if-1.0.0
cipher-0.2.5
clap-2.33.3
concurrent-queue-1.2.2
const_fn-0.4.5
cookie-0.14.4
cpuid-bool-0.1.2
cpuid-bool-0.2.0
crossbeam-queue-0.2.3
crossbeam-utils-0.7.2
crossbeam-utils-0.8.3
crypto-mac-0.10.0
ctor-0.1.19
ctr-0.6.0
curl-0.4.34
curl-sys-0.4.40+curl-7.75.0
darling-0.10.2
darling_core-0.10.2
darling_macro-0.10.2
dashmap-4.0.2
data-encoding-2.3.2
digest-0.9.0
discard-1.0.4
encoding_rs-0.8.28
event-listener-2.5.1
fastrand-1.4.0
flume-0.9.2
fnv-1.0.7
form_urlencoded-1.0.1
funty-1.1.0
futures-0.3.13
futures-channel-0.3.13
futures-core-0.3.13
futures-executor-0.3.13
futures-io-0.3.13
futures-lite-1.11.3
futures-macro-0.3.13
futures-sink-0.3.13
futures-task-0.3.13
futures-util-0.3.13
generic-array-0.14.4
getrandom-0.1.16
getrandom-0.2.2
ghash-0.3.1
gloo-timers-0.2.1
hashbrown-0.9.1
hermit-abi-0.1.18
hkdf-0.10.0
hmac-0.10.1
http-0.2.3
http-client-6.3.3
http-types-2.10.0
httparse-1.3.5
ident_case-1.0.1
idna-0.2.2
infer-0.2.3
instant-0.1.9
isahc-0.9.14
itoa-0.4.7
js-sys-0.3.48
kv-log-macro-1.0.7
lazy_static-1.4.0
lexical-core-0.7.5
libc-0.2.87
libnghttp2-sys-0.1.6+1.43.0
libz-sys-1.1.2
lock_api-0.4.2
log-0.4.14
matches-0.1.8
maybe-uninit-2.0.0
memchr-2.3.4
mime-0.3.16
mime_guess-2.0.3
nb-connect-1.0.3
nom-6.1.2
num_cpus-1.13.0
once_cell-1.7.2
opaque-debug-0.3.0
openssl-probe-0.1.2
openssl-sys-0.9.60
parking-2.0.0
percent-encoding-2.1.0
pin-project-1.0.5
pin-project-internal-1.0.5
pin-project-lite-0.1.12
pin-project-lite-0.2.5
pin-utils-0.1.0
pkg-config-0.3.19
polling-2.0.2
polyval-0.4.5
ppv-lite86-0.2.10
proc-macro-hack-0.5.19
proc-macro-nested-0.1.7
proc-macro2-1.0.24
quote-1.0.9
radium-0.5.3
rand-0.7.3
rand-0.8.3
rand_chacha-0.2.2
rand_chacha-0.3.0
rand_core-0.5.1
rand_core-0.6.2
rand_hc-0.2.0
rand_hc-0.3.0
regex-1.4.3
regex-syntax-0.6.22
route-recognizer-0.2.0
rustc_version-0.2.3
ryu-1.0.5
schannel-0.1.19
scopeguard-1.1.0
semver-0.9.0
semver-parser-0.7.0
serde-1.0.123
serde_derive-1.0.123
serde_json-1.0.64
serde_qs-0.7.2
serde_urlencoded-0.7.0
sha1-0.6.0
sha2-0.9.3
signal-hook-0.3.6
signal-hook-registry-1.3.0
simple-mutex-1.1.5
slab-0.4.2
sluice-0.5.4
socket2-0.3.19
spinning_top-0.2.2
stable_deref_trait-1.2.0
standback-0.2.15
static_assertions-1.1.0
stdweb-0.4.20
stdweb-derive-0.5.3
stdweb-internal-macros-0.2.9
stdweb-internal-runtime-0.1.5
strsim-0.9.3
subtle-2.4.0
surf-2.2.0
sval-1.0.0-alpha.5
syn-1.0.60
tap-1.0.1
textwrap-0.11.0
thiserror-1.0.24
thiserror-impl-1.0.24
thread_local-1.1.3
tide-0.16.0
time-0.2.25
time-macros-0.1.1
time-macros-impl-0.1.1
tinyvec-1.1.1
tinyvec_macros-0.1.0
tracing-0.1.25
tracing-attributes-0.1.13
tracing-core-0.1.17
tracing-futures-0.2.5
typenum-1.12.0
unicase-2.6.0
unicode-bidi-0.3.4
unicode-normalization-0.1.17
unicode-width-0.1.8
unicode-xid-0.2.1
universal-hash-0.4.0
url-2.2.1
value-bag-1.0.0-alpha.6
vcpkg-0.2.11
vec-arena-1.0.0
version_check-0.9.2
waker-fn-1.1.0
wasi-0.9.0+wasi-snapshot-preview1
wasi-0.10.2+wasi-snapshot-preview1
wasm-bindgen-0.2.71
wasm-bindgen-backend-0.2.71
wasm-bindgen-futures-0.4.21
wasm-bindgen-macro-0.2.71
wasm-bindgen-macro-support-0.2.71
wasm-bindgen-shared-0.2.71
web-sys-0.3.48
wepoll-sys-3.0.1
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
wyz-0.2.0
"

inherit cargo

DESCRIPTION="An alternative private front-end to Reddit"
HOMEPAGE="https://github.com/spikecodes/libreddit"
SRC_URI="https://api.github.com/repos/spikecodes/libreddit/tarball/v0.3.1 -> libreddit-v0.3.1.tar.gz
	$(cargo_crate_uris ${CRATES})"

LICENSE="GPL3"
SLOT="0"
KEYWORDS="*"

src_unpack() {
	cargo_src_unpack
	rm -rf ${S}
	mv ${WORKDIR}/spikecodes-libreddit-* ${S} || die
}

src_install() {
	cargo_src_install

	dodoc README.md
}