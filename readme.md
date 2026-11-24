# Seme WebStack

Seme WebStack is a Docker Compose development environment that serves PHP applications with Nginx and PHP-FPM. It includes PHP-FPM image definitions for PHP 7.4 and PHP 8.2–8.5; the Compose configuration defaults to PHP 8.5.

The application files are mounted from the repository root into both containers at `/var/www/html`. Nginx listens on host port `8080`, and forwards PHP requests to the `php` service.

[Baca dokumentasi dalam Bahasa Indonesia](readme-id.md).

## Requirements

- Docker Engine with the Docker Compose plugin (`docker compose`)
- Git, to clone the repository

## Quick start

Clone the repository and enter it:

```sh
git clone https://github.com/drosanda/seme_webstack.git
cd seme_webstack
```

Create the external Docker network required by Compose, then build and start the services:

```sh
docker network create seme_webstack_network
docker compose up --build
```

If the network already exists, Docker reports that; continue with `docker compose up --build`.

Place your PHP application (including its `index.php`) in the repository root. Open <http://localhost:8080/> to check the site. To stop the services, press `Ctrl+C`; run `docker compose down` to remove the containers.

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
- **Network not found:** create it with `docker network create seme_webstack_network`. The network is declared external and is not created by Compose.
- **The site does not load:** confirm both services are running with `docker compose ps`, then inspect logs with `docker compose logs`.
- **PHP requests fail:** verify the application has an `index.php` at the mounted repository root and that the `php` service is running.

## License

This project is distributed under the MIT License. See [`license.txt`](license.txt).
