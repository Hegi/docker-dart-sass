#!/bin/bash
{ set -euxo pipefail; } 2>/dev/null

VERSION=$(curl  -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/sass/dart-sass/releases/latest | jq -r ".tag_name" | sed -s 's/^v//')

sed -i '1c ARG UPSTREAM_VERSION='"${VERSION}" Dockerfile
if [ -n "$(git --no-pager diff HEAD -- Dockerfile)" ]; then
    git version
    git config user.name '[GHA] Hegistvan'
    git config user.email 'github-actions@hegistvan.com'
    git config push.followTags true
    git add Dockerfile
    git commit -m "Dart SASS version update to '${VERSION}'"
    git tag -f -m "Dart SASS version update to '${VERSION}'" -a "v${VERSION}" $(git rev-parse --short HEAD)
    git push origin --follow-tags
fi

ls -la