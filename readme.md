# Seme WebStack

Seme WebStack is a Docker Compose development environment that serves PHP applications with Nginx and PHP-FPM. It includes PHP-FPM image definitions for PHP 7.4 and PHP 8.2–8.5; the Compose configuration defaults to PHP 8.5.

The application files are mounted from the repository root into both containers at `/var/www/html`. Nginx listens on host port `8080`, and forwards PHP requests to the `php` service.

[Baca dokumentasi dalam Bahasa Indonesia](readme-id.md).

## Requirements

- Docker Engine with the Docker Compose plugin (`docker compose`), or Podman with a Compose provider such as `podman-compose`
- Git, to clone the repository

## Quick start

Clone the repository and enter it:

```sh
git clone https://github.com/drosanda/seme_webstack.git
cd seme_webstack
```

Create the external network required by Compose once for the container engine you are using, then build and start the services:

```sh
docker network create seme_webstack_network
docker compose up --build
```

If the network already exists, continue with `docker compose up --build`. The network is external, so Compose does not create or remove it.

For Podman, create the network and start the services with:

```sh
podman network create seme_webstack_network
podman compose up --build
```

`podman compose` requires an installed Compose provider.

Place your PHP application (including its `index.php`) in the repository root. Open <http://localhost:8080/> to check the site. To stop the services, press `Ctrl+C`; run `docker compose down` to remove the containers.

## Use with a Seme Framework application

You can keep `docker-compose.yml` in your application project instead of in this repository. In this setup, the Compose file and PHP application live at the project root, while the webstack configuration and PHP build context are under `docker/`.

From the application project root, copy the Nginx configuration and the PHP version you want from your Seme WebStack checkout. Replace `/path/to/seme_webstack` with the checkout's actual path:

```sh
mkdir -p docker
cp -R /path/to/seme_webstack/nginx docker/nginx
cp -R /path/to/seme_webstack/8.5 docker/8.5
```

Save this as `docker-compose.yml` in the application project root. This example uses PHP 8.5 and the project-specific container names `ebil_nginx` and `ebil_php`:

```yaml
services:
  nginx:
    image: nginx:1.31.10-trixie
    container_name: ebil_nginx
    ports:
      - "8080:80"
    volumes:
      - ./:/var/www/html
      - ./docker/nginx/default.conf:/etc/nginx/conf.d/default.conf
      - ./docker/nginx/nginx.conf:/etc/nginx/nginx.conf
      - ./docker/nginx/fastcgi.conf:/etc/nginx/fastcgi.conf
    depends_on:
      - php
    networks:
      - seme_webstack_network

  php:
    # Uncomment the image and build context for the PHP version you want:
    # image: drosanda/seme_webstack_php:7.4
    # build:
    #   context: ./docker/7.4/
    #   dockerfile: Dockerfile
    # image: drosanda/seme_webstack_php:8.2
    # build:
    #   context: ./docker/8.2/
    #   dockerfile: Dockerfile
    # image: drosanda/seme_webstack_php:8.3
    # build:
    #   context: ./docker/8.3/
    #   dockerfile: Dockerfile
    # image: drosanda/seme_webstack_php:8.4
    # build:
    #   context: ./docker/8.4/
    #   dockerfile: Dockerfile
    image: drosanda/seme_webstack_php:8.5
    build:
      context: ./docker/8.5/
      dockerfile: Dockerfile
    container_name: ebil_php
    volumes:
      - ./:/var/www/html
    networks:
      - seme_webstack_network

networks:
  seme_webstack_network:
    external: true
```

Create the external network before the first start. It is created once per container engine and can be reused by other projects using the same engine:

```sh
docker network create seme_webstack_network
docker compose up --build -d
```

The application root is mounted into both services. Open <http://localhost:8080/> to access it. Use `docker compose logs` to inspect service output and `docker compose down` to stop and remove the containers. The external network remains available.

The `./docker/...` paths above are for application repositories. In this WebStack repository itself, the version and Nginx directories are at the top level, so its Compose file uses `./8.5/` and `./nginx/`.

### Podman

The same Compose file can be used with Podman. Install Podman and a Compose provider (for example, `podman-compose`), then create the network and start the application with Podman's Compose wrapper:

```sh
podman network create seme_webstack_network
podman compose up --build -d
```

Confirm that a Compose provider is available with `podman compose version`. Create the network and run Compose with the same Podman mode (rootless or rootful); Podman's networks are separate from Docker's. Open <http://localhost:8080/> as with Docker. Use `podman compose logs` and `podman compose down` to inspect and stop the services. The external network is not removed by `down`.

If running more than one project on the same engine, give each project's containers unique `container_name` values and ensure host port `8080` is available.

## Selecting a PHP version

The `php` service in [`docker-compose.yml`](docker-compose.yml) builds PHP 8.5 by default. To use another included version, update both its `image` tag and `build.context` to the matching top-level version directory. For example, PHP 8.4 uses:

```yaml
image: drosanda/seme_webstack_php:8.4
build:
  context: ./8.4/
  dockerfile: Dockerfile
```

Available version directories are `7.4`, `8.2`, `8.3`, `8.4`, and `8.5`. Rebuild after changing versions:

```sh
docker compose up --build
```

Each version directory contains its `Dockerfile`, PHP configuration, and platform-specific build scripts. The scripts in `build.sh` and `build.cmd` are intended for publishing multi-platform images; they use Docker Buildx and SSH-agent access. For local development, the Compose build is usually sufficient.

## Project layout

| Path | Purpose |
| --- | --- |
| `docker-compose.yml` | Nginx and PHP-FPM services and their shared network |
| `nginx/` | Nginx virtual host, main configuration, and FastCGI parameters |
| `7.4/`, `8.2/`–`8.5/` | PHP-FPM image definitions and PHP configuration |
| `docker-build-prepare.sh` | Creates and initializes a Docker Buildx builder |
| `license.txt` | MIT license |

## Troubleshooting

- **Compose cannot find a build context or Nginx config:** run Compose from the repository root and check that the paths in `docker-compose.yml` point to the top-level version and `nginx/` directories.
- **Network not found:** create it with `docker network create seme_webstack_network` or `podman network create seme_webstack_network`, depending on the engine in use. The network is declared external and is not created by Compose.
- **The site does not load:** confirm both services are running with `docker compose ps`, then inspect logs with `docker compose logs`.
- **PHP requests fail:** verify the application has an `index.php` at the mounted repository root and that the `php` service is running.

## License

This project is distributed under the MIT License. See [`license.txt`](license.txt).
