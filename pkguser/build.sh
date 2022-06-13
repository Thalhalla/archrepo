#!/bin/bash

set -ex

#export PKGDEST=$(pwd)"/${TRAVIS_TAG}"
export PKGDEST=$(pwd)"/archrepo"

if ! grep -qs "PACKAGER" ".makepkg.conf"; then
    #export PACKAGER="${TRAVIS_REPO_SLUG/\// } <${TRAVIS_BUILD_ID}@travis.build.id>"
    export PACKAGER="archrepo/\// } <100@travis.build.id>"
fi

declare -a pkgkeys=()
declare -a pkgnames=()

for pkgfile in "gpgkey.lst" "package.lst"; do
    sed -i -e "/\s*#.*/s/\s*#.*//" -e "/^\s*$/d" "${pkgfile}"
done

mapfile -t pkgkeys < "gpgkey.lst"
mapfile -t pkgnames < "package.lst"

for pkgkey in "${pkgkeys[@]}"; do
    #gpg --recv-keys --keyserver "hkp://ipv4.pool.sks-keyservers.net" "${pkgkey}"
    gpg --recv-keys "${pkgkey}"
done

#mkdir "${TRAVIS_TAG}"
mkdir -p archrepo

shopt -s nullglob
for pkghook in "hooks/"*"-pre-"*".sh"; do
    bash "${pkghook}"
done
shopt -u nullglob

if (( ${#pkgnames[@]} )); then
    #aur sync -d "${TRAVIS_REPO_SLUG#*/}" -n ${pkgnames[@]}
    pwd
    ls -alh
    ls -alh archrepo
    #aur sync -d "archrepo#*/}" -n ${pkgnames[@]}
    TRAVIS_REPO_SLUG=archrepo
    aur sync -d "${TRAVIS_REPO_SLUG#*/}" -n ${pkgnames[@]}
fi

shopt -s nullglob
for pkghook in "hooks/"*"-post-"*".sh"; do
    bash "${pkghook}"
done
shopt -u nullglob

{ set +ex; } 2>/dev/null
