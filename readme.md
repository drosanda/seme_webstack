# Seme WebStack
Seme WebStack is a Container which already has Nginx and PHP-FPM version 7.x. This container is used for development and production processes for the container based server.

This tutorial in English. For [Tutorial dalam bahasa Indonesia open this link](https://github.com/drosanda/seme_webstack/blob/master/readme-id.md).

## Change log
Here is the list of version change log.

### version 1.0.1
Change default PHP-FPM container to 7.4

### version 1.0.0
This is initial version.

## Stuktur File dan direktori

Here is the explanation for file and directory structure:

```
|-- code (directory for php source code)
|---- index.php (contain only phpinfo for testing purpose)
|- conf (Directory for configuration)
|- php
|---- Dockerfile (Dockerfile for PHP-FPM image)
|- docker-compose.yml (File for NGINX and docker-compose configuration)
|- license.txt
|- readme-id.md (readme for Bahasa)
|- readme.md (readme for English)
```

## Prerequisited
Before doing anything, first download and install latest version of docker.
- [Docker for Windows](https://hub.docker.com/editions/community/docker-ce-desktop-windows/)
- [Docker for Mac](https://hub.docker.com/editions/community/docker-ce-desktop-mac/)

## Download and Install

This is the way of download and install SEME_WebStack.

### Download using git in windows

Please make sure you have already installed git for you computer.

We assumed you want to installed on drive D.

Run this command from terminal, CMD or CMDER.
```
d:
git clone https://github.com/drosanda/seme_webstack.git
cd  seme_webstack
```
### Download using git in mac

Please make sure you have already installed git for you computer.

We assumed you want to installed on current user home directory.

Run this command from terminal.

```
cd
git clone https://github.com/drosanda/seme_webstack.git
cd  seme_webstack
```

### Building PHP-FPM image

After clone or download we have to build PHP-FPM image.
This process will take a while depends on your internet connection and your computer specification.

On inside seme_webstack directory, run this command.

```
cd php
docker build -t seme_webstack_php .
```

Site back and relax because this process will takes more times than you wanted.

### Running Docker Compose
After building PHP image completed, back to seme_webstack directory by executing this command and then execute docker compose.

```
cd ..
docker-compose up
```

## Test the Container
After docker compose finished, you can try open http://localhost/ to see the container already started or not.


## Using the container

for using this container you can combine the source code by using `git submodule` or `copy paste` directly to inside `code` directory.

### Using `git submodule`

We assuming you install seme_webstack same way with download and install.

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

# License
This project under licensed on MIT more information of license can be found on license.txt
