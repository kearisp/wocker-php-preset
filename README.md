# PHP preset for Wocker

[![Version](https://img.shields.io/badge/version-2.0.0-blue.svg)](https://github.com/kearisp/wocker-php-preset)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](./LICENSE)

A lightweight and efficient preset for developing php applications with the Wocker workspace.


## Installation

You can add this preset to an existing Wocker project:

```shell
ws preset:install php
```


## Features

- 🚀 Ready-to-use php environment
- 🔄 Automatic dependencies installation
- 📁 Support for initialization scripts


## Usage

### Initialization Scripts

You can mount a directory with custom initialization scripts that will run on container startup:

```shell
ws volume:mount ./my-scripts:/etc/wocker/init-user.d
```

Scripts are executed in alphabetical order. Consider using numeric prefixes (e.g., `10-setup.sh`, `20-migrate.sh`) to control execution order.


### Environment Variables

The preset supports common Wocker environment variables, plus:

- `VIRTUAL_PORT`: Default port your php application should listen on (provided by nginx-proxy)


### Docker Image

This preset uses the official php Docker image ([`php`](https://hub.docker.com/_/php)).

```shell
ws build-args:set IMAGE_VERSION=8.3-apache
```

Available options: `8.1-apache`, `8.2-apache`, `8.3-apache`.

For a complete list of available php versions, see: [https://hub.docker.com/_/php/tags](https://hub.docker.com/_/php/tags)


### Extensions

Extensions are configured via a single `PHP_EXTENSIONS` build arg containing a comma-separated list of extension names:

```shell
ws build-args:set PHP_EXTENSIONS=pdo_mysql,redis,xdebug
```

Available options: `pdo_mysql`, `mysqli`, `pgsql`, `pdo_pgsql`, `gd`, `zip`, `memcache`, `memcached`, `http`, `intl`, `pcntl`, `soap`, `xdebug`, `uopz`, `gettext`, `bcmath`, `sockets`, `imagick`, `redis`, `ldap`, `mongodb`.

When `xdebug` is included, you can also set its mode via `XDEBUG_MODE`:

```shell
ws build-args:set XDEBUG_MODE=debug
```

Available options: `off`, `develop`, `coverage`, `debug`, `gcstats`, `profile`, `trace`.


## Breaking Changes

### v2.0.0

Extensions are now configured via a single `PHP_EXTENSIONS` build arg with a comma-separated list of extension names, instead of a separate boolean build arg per extension in v1.x.

**Before (v1.x):**

```shell
ws build-args:set PDO_MYSQL_ENABLE=true
ws build-args:set REDIS_ENABLE=true
ws build-args:set XDEBUG_ENABLE=true
```

**After (v2.x):**

```shell
ws build-args:set PHP_EXTENSIONS=pdo_mysql,redis,xdebug
```

If you're upgrading from v1.x, re-check which `*_ENABLE` args you had set and migrate them into a single `PHP_EXTENSIONS` value.


## Prerequisites

- Docker installed and running
- Wocker CLI installed
- Basic understanding of php


## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

_This preset is part of the [Wocker](https://kearisp.github.io/wocker) ecosystem._
