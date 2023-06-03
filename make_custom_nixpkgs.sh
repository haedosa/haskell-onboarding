#!/usr/bin/env bash

mkdir nixpkgs && cd nixpkgs
git init && git remote add origin https://github.com/NixOS/nixpkgs.git && git branch -m main
git fetch --depth 1 origin 52e3e80afff4b16ccb7c52e9f0f5220552f03d04
git checkout FETCH_HEAD