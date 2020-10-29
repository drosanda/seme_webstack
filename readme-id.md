# Seme WebStack (Bahasa)
Seme WebStack adalah Container yang sudah memiliki Nginx dan PHP-FPM versi 7.x didalamya. Kontainer ini digunakan untuk proses pengembangan aplikasi maupun pada tingkat produksi untuk penggunaan server berbasis kontainer.

Tutorial ini ada dalam Bahasa Indonesia.
For [English open this link](https://github.com/drosanda/seme_webstack).

## Catatan perubahan
Berikut ini adalah catatan perubahan versi nya

### version 1.0.1
Change default PHP-FPM container to 7.4.

### version 1.0.0
This is initial version.

## Stuktur File dan direktori

File container ini terdiri dari beberapa file dan direktori. Berikut ini adalah penjelasannya.

```
|-- code (Direktori digunakan untuk menyimpan source code yang akan dijalankan didalam container)
|---- index.php (berisi phpinfo untuk melihat versi php yang telah terinstal)
|- conf (Direktori untuk pengaturan php-fpm dan nginx)
|- php
|---- Dockerfile (file yang berisi pengaturan untuk pembuatan container PHP-FPM)
|- docker-compose.yml (file yang berisi pengaturan untuk docker compose)
|- license.txt (file yang berisi tentang dokumentasi lisensi -- dalam bahasa inggris)
|- readme-id.md (file dokumentasi berbahasa indonesia)
|- readme.md (file dokumentasi berbahasa inggris)
```

## Prasyarat
Sebelum melakukan apa pun, unduh dan instal Docker versi terbaru.

- [Docker untuk Windows](https://hub.docker.com/editions/community/docker-ce-desktop-windows/)
- [Docker untuk Mac](https://hub.docker.com/editions/community/docker-ce-desktop-mac/)

## Download dan Instal

Ini adalah cara mengunduh dan menginstal SEME_WebStack.

### Unduh menggunakan git di windows

Pastikan Anda telah menginstal git untuk komputer Anda.

Kami berasumsi Anda ingin menginstal pada drive D.

Jalankan perintah ini dari terminal, CMD atau CMDER.

```
d:
git clone https://github.com/drosanda/seme_webstack.git
cd  seme_webstack
```

### Unduh menggunakan git di mac

Pastikan Anda telah menginstal git untuk komputer Anda.

Kami berasumsi Anda ingin menginstal pada direktori /home/pengguna/ saat ini.

Jalankan perintah ini dari terminal.

```
cd
git clone https://github.com/drosanda/seme_webstack.git
cd  seme_webstack
```

### Membuat image untuk PHP-FPM

Setelah clone atau download kita harus Membuat image PHP-FPM.

Proses ini akan memakan waktu cukup lama tergantung koneksi internet dan spesifikasi komputer Anda.

Di dalam direktori seme_webstack, jalankan perintah ini.

```
cd php
docker build -t seme_webstack_php .
```

Bersantai lah sedikit, karena proses ini akan memakan waktu lebih lama dari yang Anda kira :D

### Menjalankan Docker Compose

Setelah membangun image PHP selesai, kembali ke direktori seme_webstack dengan menjalankan perintah ini dan kemudian jalankan pembuatan docker.

```
cd ..
docker-compose up
```

## Uji Container
Setelah proses docker compose selesai, Anda dapat mencoba membuka http://localhost/ untuk melihat container sudah berjalan atau belum.

## Implementasi

Untuk proses implementasi, bisa menggunakan `git submodule` atau dengan `copy paste` ke dalam direktori`code`.

### Implementasi menggunakan `git submodule`

Asumsikan anda menginstal git sama seperti dalam proses download dan instal.

#### Windows

Untuk windows, jalankan ini di terminal atau CMD.
```
D:
cd seme_webstack
RMDIR /Q/S code
git submodule https://github.com/drosanda/seme-framework.git code
```

#### Mac

Untuk mac, jalankan ini di terminal atau CMD.
```
cd
cd seme_webstack
rm -fr code
git submodule https://github.com/drosanda/seme-framework.git code
```

## Lisensi
Proyek ini di bawah lisensi MIT informasi lebih lanjut tentang lisensi dapat ditemukan pada file license.txt
