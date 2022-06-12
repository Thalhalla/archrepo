FROM archlinux:base-devel

ARG TRAVIS_REPO_SLUG
ARG TRAVIS_BUILD_ID
ARG TRAVIS_TAG

COPY ./.ci/docker-glibc-workaround.sh /docker-glibc-workaround.sh

RUN gpg-agent --daemon \
&& pacman-key --init \
&& sh /docker-glibc-workaround.sh \
&& pacman -Syu --needed --noconfirm base-devel git \
&& yes y | pacman -Scc --noconfirm \
&& useradd -m -G wheel -s /bin/bash pkguser \
&& echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/wheel

USER pkguser

WORKDIR /home/pkguser
