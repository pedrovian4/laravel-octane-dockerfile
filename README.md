# Laravel Octane Swoole Dockerfile

---

## 🇬🇧 English

### Overview

This repository provides a production-ready, multi-stage Dockerfile for containerizing a Laravel application powered by Octane and Swoole on Alpine Linux. It's optimized for high performance and lean image sizes.

### Features

* **Multi-Stage Build**: Composer dependencies, Node assets, and final PHP runtime are handled in separate stages.
* **PHP 8.4 CLI on Alpine** with essential extensions: Swoole, Redis, PostgreSQL, MySQL, GD, Intl, Vips, etc.
* **Supervisor**: Manages processes—Octane server, Horizon, scheduler, and Nightwatch agent via `laravel.conf`.
* **Production Caching**: Automates `config:cache`, `route:cache`, `view:cache`, and `event:cache`.
* **Custom Build Args**: `PHP_VERSION`, `COMPOSER_VERSION`, `NODE_VERSION`, `TZ`, `WWWUSER`, `WWWGROUP`.

### Prerequisites

* Docker
* (Optional) Docker Compose

### Building the Image

```bash
docker build \
  --build-arg PHP_VERSION=8.4 \
  --build-arg COMPOSER_VERSION=2.8 \
  --build-arg NODE_VERSION=22 \
  --build-arg WWWUSER=1000 \
  --build-arg WWWGROUP=1000 \
  --build-arg TZ="America/Sao_Paulo" \
  -t laravel-octane:latest .
```

### Running the Container

```bash
docker run --rm -it \
  -p 8000:8000 \
  -v $(pwd):/var/www/html \
  -e APP_ENV=production \
  -e APP_KEY=base64:YOUR_APP_KEY \
  laravel-octane:latest
```

### Configuration

* **Dockerfile Args**:

  * `PHP_VERSION` (default: 8.4)
  * `COMPOSER_VERSION` (default: 2.8)
  * `NODE_VERSION` (default: 22)
  * `WWWUSER`/`WWWGROUP` (file permissions)
  * `TZ` (timezone)

* **Supervisor Jobs (`laravel.conf`)**:

  * **octane**: `php artisan octane:start --server=swoole --host=0.0.0.0 --port=8000`
  * **horizon**: `php artisan horizon`
  * **schedule**: `php artisan schedule:work`
  * **nightwatch**: `php artisan nightwatch:agent`

### Customization

* Modify PHP extensions via `install-php-extensions`.
* Adjust Supervisor jobs in `laravel.conf`.
* Supply custom `php.ini` or Supervisor configs by replacing default files.

### Extending with Docker Compose

Define services (database, Redis, etc.) in a `docker-compose.yml` to work alongside this image.

### Author

Pedro Viana

---

## 🇧🇷 Português (Brasil)

### Visão Geral

Este repositório oferece um Dockerfile multi-stage pronto para produção, que containeriza uma aplicação Laravel usando Octane e Swoole em Alpine Linux. É otimizado para alto desempenho e imagens enxutas.

### Funcionalidades

* **Build Multi-Stage**: Instala dependências Composer, assetes Node e configura o runtime PHP em estágios separados.
* **PHP 8.4 CLI no Alpine** com extensões essenciais: Swoole, Redis, PostgreSQL, MySQL, GD, Intl, Vips, etc.
* **Supervisor**: Gerencia processos—servidor Octane, Horizon, scheduler e agente Nightwatch via `laravel.conf`.
* **Cache para Produção**: Executa automaticamente `config:cache`, `route:cache`, `view:cache` e `event:cache`.
* **Build Args Personalizáveis**: `PHP_VERSION`, `COMPOSER_VERSION`, `NODE_VERSION`, `TZ`, `WWWUSER`, `WWWGROUP`.

### Pré-requisitos

* Docker
* (Opcional) Docker Compose

### Construindo a Imagem

```bash
docker build \
  --build-arg PHP_VERSION=8.4 \
  --build-arg COMPOSER_VERSION=2.8 \
  --build-arg NODE_VERSION=22 \
  --build-arg WWWUSER=1000 \
  --build-arg WWWGROUP=1000 \
  --build-arg TZ="America/Sao_Paulo" \
  -t laravel-octane:latest .
```

### Executando o Container

```bash
docker run --rm -it \
  -p 8000:8000 \
  -v $(pwd):/var/www/html \
  -e APP_ENV=production \
  -e APP_KEY=base64:SUA_CHAVE \
  laravel-octane:latest
```

### Configuração

* **Args do Dockerfile**:

  * `PHP_VERSION` (padrão: 8.4)
  * `COMPOSER_VERSION` (padrão: 2.8)
  * `NODE_VERSION` (padrão: 22)
  * `WWWUSER`/`WWWGROUP` (permissões de arquivos)
  * `TZ` (fuso horário)

* **Tarefas do Supervisor (`laravel.conf`)**:

  * **octane**: `php artisan octane:start --server=swoole --host=0.0.0.0 --port=8000`
  * **horizon**: `php artisan horizon`
  * **schedule**: `php artisan schedule:work`
  * **nightwatch**: `php artisan nightwatch:agent`

### Personalização

* Alterar extensões PHP via `install-php-extensions`.
* Ajustar jobs do Supervisor em `laravel.conf`.
* Substituir `php.ini` ou configurações do Supervisor conforme necessário.

### Extensão com Docker Compose

Crie um `docker-compose.yml` para orquestrar serviços (banco, Redis etc.) junto com esta imagem.

### Autor

Pedro Viana
