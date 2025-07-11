# Laravel Octane Swoole Dockerfile

Production-ready multi-stage Dockerfile to containerize your Laravel Octane application using Swoole on Alpine Linux.

## Overview

This repository provides a streamlined Docker setup featuring three stages:

1. **vendor** (Composer): Installs PHP dependencies with optimized autoloader.
2. **assets** (Node): Builds front-end assets via Vite.
3. **prod** (PHP): PHP 8.4 CLI on Alpine with essential extensions and Supervisor to orchestrate processes.

Built to support high-performance Laravel services with:

* **Laravel Octane (Swoole)**
* **Laravel Horizon**
* **Scheduler**
* **Nightwatch Agent**

## Features

* **Multi-Stage Build** for lean images and cache efficiency.
* **Optimized PHP Extensions** (Swoole, Redis, PostgreSQL, MySQL, GD, Intl, Vips, etc.).
* **Supervisor Configuration** (`laravel.conf`) to manage Octane, Horizon, schedule\:work, and Nightwatch.
* **Production Caching**: Automates `php artisan config:cache`, `route:cache`, `view:cache`, and `event:cache`.
* **Customizable Build Args** for PHP\_VERSION, COMPOSER\_VERSION, NODE\_VERSION, TZ, WWWUSER, and WWWGROUP.

## Prerequisites

* [Docker](https://docs.docker.com/get-docker/)
* (Optional) [Docker Compose](https://docs.docker.com/compose/)

## Building the Image

```bash
docker build \
  --build-arg PHP_VERSION=8.4 \
  --build-arg COMPOSER_VERSION=2.8 \
  --build-arg NODE_VERSION=22 \
  --build-arg WWWUSER=1000 \
  --build-arg WWWGROUP=1000 \
  --build-arg TZ="America/Sao_Paulo" \
  -t my-laravel-octane:latest .
```

## Running the Container

```bash
docker run --rm -it \
  -p 8000:8000 \
  -v $(pwd):/var/www/html \
  -e APP_ENV=production \
  -e APP_KEY=base64:YOUR_APP_KEY \
  my-laravel-octane:latest
```

Adjust environment variables (`APP_ENV`, `APP_KEY`, database credentials, etc.) as needed.

## Configuration

* **Dockerfile Args**:

    * `PHP_VERSION`: PHP version (default `8.4`).
    * `COMPOSER_VERSION`: Composer version (default `2.8`).
    * `NODE_VERSION`: Node.js version (default `22`).
    * `WWWUSER` / `WWWGROUP`: Linux UID/GID for file permissions.
    * `TZ`: Timezone for container (default `America/Sao_Paulo`).

* **Supervisor (`laravel.conf`)**:

    * **octane**: `php artisan octane:start --server=swoole --host=0.0.0.0 --port=8000`
    * **horizon**: `php artisan horizon`
    * **schedule**: `php artisan schedule:work`
    * **nightwatch**: `php artisan nightwatch:agent`

## Customization

* Add or remove PHP extensions via the `install-php-extensions` command.
* Modify Supervisor jobs in `laravel.conf` to fit your workflow.
* Use a custom `php.ini` or Supervisor configuration by replacing the respective files.

## Extending with Docker Compose

Create a `docker-compose.yml` to orchestrate services (database, Redis, etc.) alongside this image.

## Author

Pedro Viana

---

*Feel free to contribute or open an issue if you find any enhancements or bugs.*
