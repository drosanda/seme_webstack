#!/bin/bash
export DOCKER_BUILDKIT=1;
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

docker buildx build --load --platform linux/amd64 --ssh default="$SSH_AUTH_SOCK" --push -t drosanda/seme_webstack_php:8.4-amd64 .

docker buildx build --load --platform linux/arm64 --ssh default="$SSH_AUTH_SOCK" --push -t drosanda/seme_webstack_php:8.4-arm64 .

docker buildx imagetools create -t drosanda/seme_webstack_php:8.4 drosanda/seme_webstack_php:8.4-amd64 drosanda/seme_webstack_php:8.4-arm64

docker push drosanda/seme_webstack_php:8.4-arm64

docker push drosanda/seme_webstack_php:8.4-amd64

docker push drosanda/seme_webstack_php:8.4