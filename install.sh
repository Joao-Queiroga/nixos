#!/bin/sh
exec nixos-install --flake ".#${@}" --option extra-substituters https://install.determinate.systems --option extra-trusted-public-keys cache.flakehub.com-3:hJuILl5sVK4iKM86JzgdXW12Y2Hwd5G07qKtHTOcDCM=
