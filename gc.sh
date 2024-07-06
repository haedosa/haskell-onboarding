#!/usr/bin/env bash

if [ -z "$1" ]; then
  echo "Usage: $0 <package-name>"
  exit 1
fi

package_name=$1$(if [[ -n "$REPLIT_ENVIRONMENT" ]]; then echo "-replit"; fi)

link_path=".nix/${package_name}"

if [ -L "$link_path" ] && [ -e "$link_path" ]; then
  output_path="$(readlink .nix/$(readlink "${link_path}"))"
else
  mkdir -p .nix
  nix develop .#${package_name} --quiet --profile .nix/${package_name} --command bash -c "exit;" > /dev/null 2>&1
  output_path="$(readlink .nix/$(readlink "${link_path}"))"
fi

echo "Output_path : $output_path"

# Get the closure of the derivation, packages with dependency on top
closure_paths=$(nix-store -qR "$output_path" | tac)
echo "Gathered closure paths..."

# Delete paths in the closure only if they are not referenced by other roots
for path in $closure_paths; do
  output=$($((grep -q nixbld /etc/group) && echo sudo || echo "") nix-store --delete "$path" --ignore-liveness 2>&1)
  status=$?
  if [ $status -eq 0 ]; then
    echo "Deleting $path"
  else
    echo "Skipping $path"
  fi
done
rm -rf "${link_path}"*

echo "Cleanup complete for $package_name"
