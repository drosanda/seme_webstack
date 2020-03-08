# Seme WebStack
Seme WebStack is container base application for development or production Seme Framework using Nginx and PHP-FPM

## version
This is initial version 1.0.0. 

## Prerequisited
Before doing anything, first download and install latest version of docker.
- [Docker for Windows](https://hub.docker.com/editions/community/docker-ce-desktop-windows/)
- [Docker for Mac](https://hub.docker.com/editions/community/docker-ce-desktop-mac/)

## Installation
For installation we have to create PHP image first.

### PHP Image
Open CMD and change dir to php directory and then execute

```CLI
docker build -t seme_webstack_php .
```
Site back and relax because this process will takes more times than you wanted.

### Docker Compose
After building PHP image completed, back parent directory and then execute docker compose


```CLI
docker-compose up
```

### Testing
After docker compose finished, you can try open (localhost)[http://localhost/] to see the container already started or not.

# License
This project under licensed on MIT more information of license can be found on license.txt
