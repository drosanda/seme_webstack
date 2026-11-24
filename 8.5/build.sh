#!/bin/bash
export DOCKER_BUILDKIT=1;
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

docker buildx build --load --platform linux/amd64 --push -t drosanda/seme_webstack_php:8.5-amd64 .

docker buildx build --load --platform linux/arm64 --push -t drosanda/seme_webstack_php:8.5-arm64 .

docker buildx imagetools create -t drosanda/seme_webstack_php:8.5 drosanda/seme_webstack_php:8.5-amd64 drosanda/seme_webstack_php:8.5-arm64

docker push drosanda/seme_webstack_php:8.5-arm64

docker push drosanda/seme_webstack_php:8.5-amd64

docker push drosanda/seme_webstack_php:8.5