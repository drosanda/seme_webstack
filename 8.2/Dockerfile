# FROM arm64v8/php:7.4-fpm-bullseye
FROM php:8.2.35-fpm-bookworm

docker buildx build --load --platform linux/amd64 --push -t drosanda/seme_webstack_php:8.2-amd64 .

docker buildx build --load --platform linux/arm64 --push -t drosanda/seme_webstack_php:8.2-arm64 .

docker buildx imagetools create -t drosanda/seme_webstack_php:8.2 drosanda/seme_webstack_php:8.2-amd64 drosanda/seme_webstack_php:8.2-arm64

docker push drosanda/seme_webstack_php:8.2-arm64

docker push drosanda/seme_webstack_php:8.2-amd64

docker push drosanda/seme_webstack_php:8.2