#!/bin/env bash

set -e
cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.."

if ! git diff-index --quiet HEAD; then
    echo "Not running rebase.sh because git working directory is dirty" >&2
    exit 1
fi

if [ -z "$1" ]; then
    echo "Usage: scripts/new-branch.sh [crate]" >&2
    exit 1
fi

crate="$1"

git checkout master
git checkout -b "$crate"

cat > "$crate.patch" <<EOF
diff --git a/action.yml b/action.yml
--- a/action.yml
+++ b/action.yml
@@ -5,6 +5,7 @@ inputs:
   crate:
     description: Name of crate as published to crates.io
     required: true
+    default: $crate
   bin:
     description: Name of binary; default = same as crate name
     required: false
EOF

git apply "$crate.patch"
rm "$crate.patch"
git commit -a -m "patch action.yml to use $crate by default"

git push -u origin "$crate"
