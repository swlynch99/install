#!/bin/env bash

set -ex

cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.."

git fetch -p origin

for remote in .git/refs/remotes/origin/*; do
    remote=$(basename "$remote")

    if [ "$remote" == HEAD ]; then
        continue
    fi

    if [ "$remote" == master ]; then
        continue
    fi

    ./scripts/rebase.sh "$remote"
done

git checkout master
