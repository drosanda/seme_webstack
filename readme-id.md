# Seme WebStack

Seme WebStack adalah lingkungan pengembangan berbasis Docker Compose untuk menjalankan aplikasi PHP dengan Nginx dan PHP-FPM. Proyek ini menyediakan konfigurasi image PHP-FPM versi 7.4 dan 8.2–8.5; konfigurasi Compose menggunakan PHP 8.5 secara default.

File aplikasi dipasang dari direktori utama repositori ke `/var/www/html` di kedua container. Nginx dapat diakses melalui port `8080` pada host dan meneruskan permintaan PHP ke layanan `php`.

[Read the documentation in English](readme.md).

## Prasyarat

- Docker Engine dengan plugin Docker Compose (`docker compose`)
- Git untuk mengkloning repositori

## Mulai cepat

Kloning repositori, lalu masuk ke direktorinya:

```sh
git clone https://github.com/drosanda/seme_webstack.git
cd seme_webstack
```

Buat network Docker eksternal yang dibutuhkan Compose, lalu bangun dan jalankan layanan:

```sh
docker network create seme_webstack_network
docker compose up --build
```

Jika network tersebut sudah ada, Docker akan memberi tahu Anda; lanjutkan dengan `docker compose up --build`.

Letakkan aplikasi PHP (termasuk `index.php`) di direktori utama repositori. Buka <http://localhost:8080/> untuk memeriksa situs. Tekan `Ctrl+C` untuk menghentikan layanan; jalankan `docker compose down` untuk menghapus container.

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
- **Network tidak ditemukan:** buat dengan `docker network create seme_webstack_network`. Network ini dideklarasikan sebagai eksternal sehingga tidak dibuat oleh Compose.
- **Situs tidak dapat dibuka:** pastikan kedua layanan berjalan dengan `docker compose ps`, lalu periksa log dengan `docker compose logs`.
- **Permintaan PHP gagal:** pastikan aplikasi memiliki `index.php` di root repositori yang dipasang dan layanan `php` sedang berjalan.

## Lisensi

Proyek ini menggunakan Lisensi MIT. Lihat [`license.txt`](license.txt).
