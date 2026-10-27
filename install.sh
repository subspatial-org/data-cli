#!/bin/sh
# Install the subspatial command-line client.
#
#   curl -fsSL https://raw.githubusercontent.com/subspatial-org/data-cli/main/install.sh | sh
#
# Downloads the release bundle for this OS and CPU from
# github.com/subspatial-org/data-cli, checks it against the release's
# SHA256SUMS, and installs subspatial and subspatiald into /usr/local/bin
# (asking for sudo only if that folder isn't writable).
#
# Settings, as environment variables for the sh side of the pipe
# (curl ... | SUBSPATIAL_VERSION=0.3.0-alpha.2 sh):
#   SUBSPATIAL_VERSION      a release such as 0.3.0-alpha.2 (default: the newest)
#   SUBSPATIAL_INSTALL_DIR  where to install (default: /usr/local/bin)
set -eu

repo="subspatial-org/data-cli"
install_dir="${SUBSPATIAL_INSTALL_DIR:-/usr/local/bin}"

say() { printf '%s\n' "$*"; }
fail() { printf 'subspatial install: %s\n' "$*" >&2; exit 1; }
have() { command -v "$1" >/dev/null 2>&1; }

have curl || fail "curl is needed to download the release"
have tar || fail "tar is needed to unpack the release"

case "$(uname -s)" in
  Linux) os=linux ;;
  Darwin) os=darwin ;;
  *) fail "this pilot has builds for Linux and macOS only, not $(uname -s)" ;;
esac
case "$(uname -m)" in
  x86_64 | amd64) arch=amd64 ;;
  aarch64 | arm64) arch=arm64 ;;
  *) fail "this pilot has builds for amd64 and arm64 only, not $(uname -m)" ;;
esac
# An Apple-silicon Mac running this shell under Rosetta reports x86_64; the
# native build is the right one there.
if [ "$os" = darwin ] && [ "$arch" = amd64 ] && [ "$(sysctl -n hw.optional.arm64 2>/dev/null || echo 0)" = 1 ]; then
  arch=arm64
fi

version="${SUBSPATIAL_VERSION:-}"
if [ -z "$version" ]; then
  # The newest published release, pre-releases included (GitHub's
  # releases/latest skips pre-releases, and every pilot build is one).
  version=$(curl -fsSL "https://api.github.com/repos/$repo/releases?per_page=10" |
    sed -n 's/.*"tag_name": *"v\{0,1\}\([^"]*\)".*/\1/p' | head -n 1) ||
    fail "could not ask GitHub for the newest release"
  [ -n "$version" ] || fail "found no release on github.com/$repo"
fi
version=${version#v}
case "$version" in
  *[!0-9A-Za-z.-]* | '') fail "not a release version: $version" ;;
esac

if [ "$os" = darwin ]; then
  bundle="subspatial-cli-$version-$os-$arch.unsigned.zip"
  have unzip || fail "unzip is needed to unpack the macOS release"
else
  bundle="subspatial-cli-$version-$os-$arch.unsigned.tar.gz"
fi
base="https://github.com/$repo/releases/download/v$version"

work=$(mktemp -d "${TMPDIR:-/tmp}/subspatial-install.XXXXXX")
trap 'rm -rf "$work"' EXIT INT TERM

say "Downloading subspatial $version for $os/$arch..."
curl -fsSL -o "$work/$bundle" "$base/$bundle" || fail "could not download $base/$bundle"
curl -fsSL -o "$work/SHA256SUMS" "$base/SHA256SUMS" || fail "could not download $base/SHA256SUMS"

expected=$(awk -v f="$bundle" '$2 == f { print $1 }' "$work/SHA256SUMS")
[ -n "$expected" ] || fail "SHA256SUMS has no entry for $bundle"
if have sha256sum; then
  actual=$(sha256sum "$work/$bundle" | awk '{ print $1 }')
elif have shasum; then
  actual=$(shasum -a 256 "$work/$bundle" | awk '{ print $1 }')
else
  fail "sha256sum or shasum is needed to check the download"
fi
[ "$actual" = "$expected" ] || fail "checksum mismatch for $bundle: expected $expected, got $actual. Nothing was installed."
say "Checksum OK."

if [ "$os" = darwin ]; then
  unzip -q "$work/$bundle" -d "$work/unpacked"
else
  mkdir "$work/unpacked"
  tar -xzf "$work/$bundle" -C "$work/unpacked"
fi
src="$work/unpacked/subspatial-cli-$version-$os-$arch"
[ -f "$src/subspatial" ] && [ -f "$src/subspatiald" ] || fail "the bundle doesn't contain subspatial and subspatiald"

sudo=""
if [ -d "$install_dir" ] && [ -w "$install_dir" ]; then
  :
elif [ ! -e "$install_dir" ] && mkdir -p "$install_dir" 2>/dev/null; then
  :
elif have sudo; then
  say "Installing into $install_dir needs administrator rights; sudo may ask for your password."
  sudo=sudo
else
  fail "can't write to $install_dir and sudo isn't available; rerun with SUBSPATIAL_INSTALL_DIR=\$HOME/.local/bin"
fi
$sudo mkdir -p "$install_dir"
$sudo install -m 0755 "$src/subspatial" "$src/subspatiald" "$install_dir/"
if [ "$os" = darwin ]; then
  # curl sets no quarantine flag, so this is a safeguard, not a requirement.
  $sudo xattr -c "$install_dir/subspatial" "$install_dir/subspatiald" 2>/dev/null || true
fi

say "Installed $("$install_dir/subspatial" version) into $install_dir."
case ":$PATH:" in
  *":$install_dir:"*) say "Next: subspatial login --api https://app.subspatial.io (or the site you were invited to)" ;;
  *) say "$install_dir isn't on your PATH. Add it, for example: echo 'export PATH=\"$install_dir:\$PATH\"' >> ~/.zshrc (or ~/.bashrc), then open a new terminal." ;;
esac
