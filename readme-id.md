# Seme WebStack

Seme WebStack adalah lingkungan pengembangan berbasis Docker Compose untuk menjalankan aplikasi PHP dengan Nginx dan PHP-FPM. Proyek ini menyediakan konfigurasi image PHP-FPM versi 7.4 dan 8.2–8.5; konfigurasi Compose menggunakan PHP 8.5 secara default.

File aplikasi dipasang dari direktori utama repositori ke `/var/www/html` di kedua container. Nginx dapat diakses melalui port `8080` pada host dan meneruskan permintaan PHP ke layanan `php`.

[Read the documentation in English](readme.md).

## Prasyarat

- Docker Engine dengan plugin Docker Compose (`docker compose`), atau Podman dengan penyedia Compose seperti `podman-compose`
- Git untuk mengkloning repositori

## Mulai cepat

Kloning repositori, lalu masuk ke direktorinya:

```sh
git clone https://github.com/drosanda/seme_webstack.git
cd seme_webstack
```

Buat network eksternal yang dibutuhkan Compose sekali untuk engine container yang digunakan, lalu bangun dan jalankan layanan:

```sh
docker network create seme_webstack_network
docker compose up --build
```

Jika network tersebut sudah ada, lanjutkan dengan `docker compose up --build`. Network ini bersifat eksternal sehingga tidak dibuat atau dihapus oleh Compose.

Untuk Podman, buat network dan jalankan layanan dengan perintah berikut:

```sh
podman network create seme_webstack_network
podman compose up --build
```

`podman compose` memerlukan penyedia Compose yang sudah terpasang.

Letakkan aplikasi PHP (termasuk `index.php`) di direktori utama repositori. Buka <http://localhost:8080/> untuk memeriksa situs. Tekan `Ctrl+C` untuk menghentikan layanan; jalankan `docker compose down` untuk menghapus container.

## Menggunakan Seme Framework

Anda dapat menyimpan `docker-compose.yml` di proyek aplikasi, bukan di repositori ini. Dalam konfigurasi ini, file Compose dan aplikasi PHP berada di direktori utama proyek, sedangkan konfigurasi webstack dan konteks build PHP berada di dalam `docker/`.

Dari direktori utama proyek aplikasi, salin konfigurasi Nginx dan direktori versi PHP yang ingin digunakan dari checkout Seme WebStack. Ganti `/path/to/seme_webstack` dengan lokasi checkout yang sebenarnya:

```sh
mkdir -p docker
cp -R /path/to/seme_webstack/nginx docker/nginx
cp -R /path/to/seme_webstack/8.5 docker/8.5
```

Simpan konfigurasi berikut sebagai `docker-compose.yml` di direktori utama proyek aplikasi. Contoh ini menggunakan PHP 8.5 dan nama container khusus proyek `ebil_nginx` dan `ebil_php`:

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
    # Aktifkan image dan build context untuk versi PHP yang ingin digunakan:
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

Buat network eksternal sebelum menjalankan untuk pertama kali. Network dibuat sekali untuk setiap engine container dan dapat digunakan kembali oleh proyek lain yang menggunakan engine yang sama:

```sh
docker network create seme_webstack_network
docker compose up --build -d
```

Direktori utama aplikasi dipasang ke kedua layanan. Buka <http://localhost:8080/> untuk mengaksesnya. Gunakan `docker compose logs` untuk melihat keluaran layanan dan `docker compose down` untuk menghentikan serta menghapus container. Network eksternal tetap tersedia.

Path `./docker/...` di atas digunakan untuk repositori aplikasi. Di repositori Seme WebStack ini, direktori versi dan Nginx berada langsung di root, sehingga file Compose menggunakan `./8.5/` dan `./nginx/`.

### Podman

File Compose yang sama dapat digunakan dengan Podman. Instal Podman dan penyedia Compose (misalnya `podman-compose`), lalu buat network dan jalankan aplikasi menggunakan wrapper Compose Podman:

```sh
podman network create seme_webstack_network
podman compose up --build -d
```

Pastikan penyedia Compose tersedia dengan `podman compose version`. Buat network dan jalankan Compose dalam mode Podman yang sama (rootless atau rootful); network Podman terpisah dari network Docker. Akses aplikasi melalui <http://localhost:8080/>. Gunakan `podman compose logs` dan `podman compose down` untuk melihat log dan menghentikan layanan. Network eksternal tidak dihapus oleh `down`.

Jika menjalankan lebih dari satu proyek pada engine yang sama, gunakan nilai `container_name` yang unik untuk setiap proyek dan pastikan port host `8080` tersedia.

## Memilih versi PHP

Layanan `php` di [`docker-compose.yml`](docker-compose.yml) menggunakan PHP 8.5 secara default. Untuk menggunakan versi lain yang tersedia, ubah tag `image` dan `build.context` agar mengarah ke direktori versi yang sama. Contoh untuk PHP 8.4:

```yaml
image: drosanda/seme_webstack_php:8.4
build:
  context: ./8.4/
  dockerfile: Dockerfile
```

Direktori versi yang tersedia: `7.4`, `8.2`, `8.3`, `8.4`, dan `8.5`. Bangun ulang setelah mengganti versi:

```sh
docker compose up --build
```

Setiap direktori versi berisi `Dockerfile`, konfigurasi PHP, dan skrip build khusus platform. Skrip `build.sh` dan `build.cmd` ditujukan untuk menerbitkan image multi-platform; skrip tersebut menggunakan Docker Buildx dan akses SSH-agent. Untuk pengembangan lokal, build melalui Compose biasanya sudah cukup.

## Struktur proyek

| Path | Kegunaan |
| --- | --- |
| `docker-compose.yml` | Layanan Nginx dan PHP-FPM serta network bersama |
| `nginx/` | Virtual host Nginx, konfigurasi utama, dan parameter FastCGI |
| `7.4/`, `8.2/`–`8.5/` | Definisi image PHP-FPM dan konfigurasi PHP |
| `docker-build-prepare.sh` | Membuat dan menginisialisasi builder Docker Buildx |
| `license.txt` | Lisensi MIT |

## Pemecahan masalah

- **Compose tidak menemukan build context atau konfigurasi Nginx:** jalankan Compose dari direktori utama repositori dan pastikan path di `docker-compose.yml` mengarah ke direktori versi dan `nginx/` yang berada di root.
- **Network tidak ditemukan:** buat dengan `docker network create seme_webstack_network` atau `podman network create seme_webstack_network`, sesuai engine yang digunakan. Network ini dideklarasikan sebagai eksternal sehingga tidak dibuat oleh Compose.
- **Situs tidak dapat dibuka:** pastikan kedua layanan berjalan dengan `docker compose ps`, lalu periksa log dengan `docker compose logs`.
- **Permintaan PHP gagal:** pastikan aplikasi memiliki `index.php` di root repositori yang dipasang dan layanan `php` sedang berjalan.

## Lisensi

Proyek ini menggunakan Lisensi MIT. Lihat [`license.txt`](license.txt).
