#!/bin/env bash

set -e

cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.."

rm .github/workflows/*

for crate in $(cat crates.txt); do
  cat > ".github/workflows/$crate.yml" <<EOF
name: $crate

on:
  push:
    branches:
      - $crate
  workflow_dispatch:

jobs:
  build:
    uses: ./.github/workflows/build.yml
    with:
      crate: $crate
    permissions:
      contents: write
    secrets: inherit
EOF
done

cp -f .github/custom/* .github/workflows
cp -f .github/staging/* .github/workflows
