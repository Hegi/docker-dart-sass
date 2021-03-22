#!/bin/bash

VERSION=$(curl  -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/sass/dart-sass/releases/latest | jq -r ".tag_name" | sed -s 's/^v//')

sed -i '1c ARG UPSTREAM_VERSION='"${VERSION}" Dockerfile
if $(! git diff-index --quiet HEAD -- Dockerfile); then
    git version
    git config user.name '[GHA] Hegistvan'
    git config user.email 'github-actions@hegistvan.com'
    git config push.followTags true
    git add Dockerfile
    git commit -m "Dart SASS version update to '${VERSION}'"
    git tag -fa "v${VERSION}" $(git rev-parse --short HEAD)
    git push origin --follow-tags
fi
