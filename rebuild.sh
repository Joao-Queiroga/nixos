#!/bin/sh
exec nixos-rebuild boot --flake . --option extra-substituters "https://attic.xuyh0120.win/lantian" --option extra-trusted-public-keys "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
