#!/usr/bin/env bash

set -xeu

branch=$(git rev-parse --abbrev-ref HEAD)
commit=$(git rev-parse --short HEAD)

commitSuffix="$( \
  [[ -z $(git status -s) ]] \
    && echo "$commit" \
    || echo "dirty-$(date '+%Y-%m-%d-%H-%M-%S')" \
)"

packages='
  aragon-api
  aragon-api-react
  aragon-rpc-messenger
  aragon-wrapper
'

for pkg in $packages; do
  cd packages/$pkg
  version=$(jq -r '.version' package.json)
  yarn version --new-version "$version-$branch-$commitSuffix" --no-git-tag-version
  npm publish --tag $commit
  cd -
done
