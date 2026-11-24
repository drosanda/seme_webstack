#!/bin/bash
export DOCKER_BUILDKIT=1;
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

docker buildx build --load --ssh default="$SSH_AUTH_SOCK" --platform linux/amd64 --push -t drosanda/seme_webstack_php:8.3-amd64 .

docker buildx build --load --ssh default="$SSH_AUTH_SOCK" --platform linux/arm64 --push -t drosanda/seme_webstack_php:8.3-arm64 .

docker buildx imagetools create -t drosanda/seme_webstack_php:8.3 drosanda/seme_webstack_php:8.3-amd64 drosanda/seme_webstack_php:8.3-arm64

docker push drosanda/seme_webstack_php:8.3-arm64

docker push drosanda/seme_webstack_php:8.3-amd64

docker push drosanda/seme_webstack_php:8.3