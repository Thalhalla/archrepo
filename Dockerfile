FROM archlinux:base-devel

ARG TRAVIS_REPO_SLUG
ARG TRAVIS_BUILD_ID
ARG TRAVIS_TAG

COPY ./.ci/docker-glibc-workaround.sh /docker-glibc-workaround.sh
RUN sh /docker-glibc-workaround.sh \
&& pacman-key --init \
&& pacman -Syu --needed --noconfirm base-devel git

RUN useradd -m -G wheel -s /bin/bash pkguser \
&& echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/wheel

USER pkguser

WORKDIR /home/pkguser
