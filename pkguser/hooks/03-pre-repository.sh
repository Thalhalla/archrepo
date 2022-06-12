#!/bin/bash

declare -r pkgurl="https://github.com/${TRAVIS_REPO_SLUG}/releases/download/${TRAVIS_TAG}"
declare -r pkgrepository="${TRAVIS_REPO_SLUG#*/}"
declare -a pkgnames=() && mapfile -t pkgnames < "package.lst"

cd "${TRAVIS_TAG}"
if curl -L -O -f "${pkgurl}/${pkgrepository}.{db,files}.tar.gz"; then
    ln -s "${pkgrepository}.db.tar.gz" "${pkgrepository}.db"
    ln -s "${pkgrepository}.files.tar.gz" "${pkgrepository}.files"
else
    repo-add "${pkgrepository}.db.tar.gz"
fi
cd ".."

sudo tee -a "/etc/pacman.conf" << EOF

[${pkgrepository}]
SigLevel = Optional TrustAll
Server = file://$(pwd)/${TRAVIS_TAG}
Server = ${pkgurl}
EOF

sudo pacman -Syu --noconfirm

cd "${TRAVIS_TAG}"
while read pkgname; do
    repo-remove "${pkgrepository}.db.tar.gz" "${pkgname}"
done < <(comm -23 <(pacman -Slq "${pkgrepository}" | sort) <(aur depends -n "${pkgnames[@]}" | sort))
cd ".."
