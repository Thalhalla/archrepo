#!/bin/bash

sudo tee -a "/etc/pacman.conf" << EOF

[aurutilsci]
SigLevel = Optional TrustAll
Server = https://github.com/xeladejo/aurutilsci/releases/download/repository
EOF

sudo pacman -Syu --needed --noconfirm aurutils
