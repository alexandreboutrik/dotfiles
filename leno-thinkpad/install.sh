#!/usr/bin/env bash

# TODO: support for the X270.
# hardware-configuration.nix and networking.hostName should be changed.

if [ ! -d "./nixos" ] ; then
  echo "ERROR: No ./nixos directory found."
  exit 1
fi

cp -rf ./nixos /etc ||
{ echo "ERROR: Failed to copy ./nixos to /etc/nixos. Exiting." ; exit 1; }

echo "Done. You can now run nixos-rebuild switch."
