#!/bin/bash

set -e -u

declare -r PROGNAME="${0##*/}"
declare -i DEBUG=1
declare -r CNFFILE="${0%sh}cnf"
declare -x PATH=/usr/bin:/bin

function fatal {
  echo "${PROGNAME}: ${1:-"Fatal error"}" >&2
  exit 1
}
trap fatal ERR

# Config
[ -f "$CNFFILE" ] || fatal "Failed to find configuration ($CNFFILE)"
. "$CNFFILE"
perl_base=${perl_base%/}
perl_base=${perl_base:-/tmp}
here="${0%/*}"
build_base="$(cd ${here:-.} && pwd)"
target="${target:-""}"

# Checks
for req in arch less make sed tar uname wget; do
  which $req &>/dev/null || fatal "Missing executable ($req); maybe you need to install it"
done
[ "$(uname -s)" == Linux ] || fatal 'This script only targets linux'
[[ "$perl_version" =~ ^5\.[0-9]{2}\.[0-9]$ ]] || fatal "Strange version requested (${perl_version:-none})"
[[ "$perl_base" =~ ^/ ]] || fatal "Not an abs path ($perl_base)"

# Test perms
cd "$build_base"
[ -d tmpl ] || fatal "Failed to find templates dir ($build_base/tmpl)"
cat /dev/null >.test_file || fatal "Cannot write to dir ($build_base)"
rm -f .test_file

# Download sources
perl_tar=perl-"$perl_version".tar.gz
[ -f "$perl_tar" ] || wget http://www.cpan.org/src/5.0/"$perl_tar" || fatal 'Failed to wget perl'
[ -f cpanminus ] || wget -O cpanminus https://cpanmin.us || fatal 'Failed to wget cpanminus'

if [ "$target" == download ]; then
  echo "Downloaded as requested" >&2
  exit 0
fi

# Prepare sources
rm -rf perl-"$perl_version"
tar xzf "$perl_tar"
cd perl-"$perl_version" || fatal "Failed to enter perl dir (perl-$perl_version)"
sed -e"s,<%base%>,$perl_base,g; s,<%version%>,$perl_version,g" <../tmpl/Policy.sh >Policy.sh

# Build
unset PERL_MB_OPT PERL_MM_OPT
./Configure -des
make && make test

# Deploy
rm -rf "$perl_base"/"$perl_version".old
[ -e "$perl_base"/"$perl_version" ] && mv -f "$perl_base"/"$perl_version" "$perl_base"/"$perl_version".old
mkdir -p "$perl_base"/"$perl_version"
make install
cd ..
rm -rf perl-"$perl_version"
sed -e"s,<%base%>,$perl_base,g; s,<%version%>,$perl_version,g" <tmpl/env >"$perl_base"/"$perl_version".env
chmod 0644 "$perl_base"/"$perl_version".env

# Patch
(cd "$perl_base"/"$perl_version"/lib && patch -p0 <"$build_base"/ExtUtils.Manifest.pm.patch)
(cd "$perl_base"/"$perl_version"/lib && patch -p0 <"$build_base"/ExtUtils.MM_Any.pm.patch)

# Cpanminus
(cd "$perl_base"/"$perl_version"/lib && rm -f perl5 && ln -s . perl5)
(. "$perl_base"/"$perl_version".env; "$perl_base"/"$perl_version"/bin/perl "$build_base"/cpanminus App::cpanminus)

# Show results
env -i "$perl_base"/"$perl_version"/bin/perl -V
