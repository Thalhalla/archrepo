#!/bin/bash

sudo sed -i -e "/\[multilib\]/,/Include/s/^#//" "/etc/pacman.conf"

sudo pacman -Syu --noconfirm
