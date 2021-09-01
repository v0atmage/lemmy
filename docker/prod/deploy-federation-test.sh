#!/bin/bash
set -e

TAG="federation-test"

sudo docker build ../../ --file Dockerfile -t "v0atmage/lemmy:$TAG"
sudo docker save "v0atmage/lemmy:$TAG" -o "$TAG.tar"
sudo chown "$(id -u):$(id -g)" "$TAG.tar"

scp "$TAG.tar" enterprise.lemmy.ml:
rm "$TAG.tar"
ssh lemmy-test "cat $TAG.tar | docker load"
ssh lemmy-test "rm $TAG.tar"
ssh lemmy-test "cd /lemmy/enterprise.lemmy.ml && docker-compose up -d"
