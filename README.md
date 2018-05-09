# [Dockery Odoo](https://github.com/xoes/dockery-odoo)

An Odoo development lifecycle management image suite for your Odoo projects **without** any Odoo itself.

Hand crafted for productivity!

It aims to provide some opinionanted overrides, additions and/or patches included which makes Odoo instance scripting a little more fun.

## Components

- Base Images
- [WIP] Migrator Image (leveraging marabunta)
- [WIP] Tester Image (remotely inspired by OCA's mqt)
- [WIP] Translator Image (for Transifex or Weblate / GitHub or GitLab)

The base images are versioned through branch names.

The other images, README, ... are in shared development on `shared` branch (and eventually merged back to the version branches).

## Image explained

- After building the image, every you have to worry about is `/opt/odoo`.

- Docker boilerplate lives in `/`.

- PATH and PYTHONPATH enabled boilerplate lies in:

    ./bin/*    -> /usr/local/bin/
    ./lib/*.py -> /usr/local/lib/python2.7/dist-packages/

### Note on `chmod +x`
We avoid cluttering Dockerfiles with `RUN chmod +x` files through setting the exeuting bit within git. After adding files to the index, just do:

```bash    
# Do not complain on .empty files (Bash only)
shopt -s dotglob
git update-index --chmod=+x \
    base/bin/* \
    base/entrypoint.d/* \
    base/lib/* \
    tester/lib/* \
    translator/lib/*
shopt -u dotglob
```

Don't foget to set `git config core.filemode true` before cloning.

This unfortunately only works on linux computers. You need to add `RUN chmod +x` on windows machines.

## Image usage

### Folder Convention

There is no way around this folder structure. No point arguing.

```bash
  vendor/
    odoo/
      cc/
      ee/  # contains ".empty" file, if empty
  src/    # your addons
  cfg/    # odoo config file(s), split them!
  Dockerfile
```

### `Dockerfile`

```dockerfile
# .docker/Dockerfile
ARG  FROM_IMAGE=xoes/dockery-odoo
FROM ${FROM_IMAGE}

# Examples of extending your project with vendored modules
## NOTE: later *modules* override their previous namesake
COPY vendor/it-projects/*   /opt/odoo/addons/010
COPY vendor/xoe/*           /opt/odoo/addons/020
COPY vendor/c2c/*           /opt/odoo/addons/030

# Example of extending your project with custom libraries
USER root
RUN pip install python-telegram-bot pandas numpy
USER odoo
```
### Project's images

#### Golden rule

1. Build your project's image
2. Build all other images

#### Build project's image

Assuming your project lives in `odoo/app` namespace:

    docker build --tag odoo/app .

or with your custom base image

    docker build --tag odoo/app --build-arg FROM_IMAGE=YOUR_PROJECT_BASE_IMAGE .

#### Build all other images

**dev-container:**

    docker build \
      --tag odoo/app:dev \
      --build-arg FROM_IMAGE=YOUR_PROJECT_IMAGE \
      https://github.com/xoes/dockery-odoo.git#shared:dev

**tester:**

    docker build \
      --tag odoo/app:tester \
      --build-arg FROM_IMAGE=YOUR_PROJECT_IMAGE \
      https://github.com/xoes/dockery-odoo.git#shared:tester

**migrator:**

    docker build \
      --tag odoo/app:migrator \
      --build-arg FROM_IMAGE=YOUR_PROJECT_IMAGE \
      https://github.com/xoes/dockery-odoo.git#shared:migrator

**translator:**

    docker build \
      --tag odoo/app:translator \
      --build-arg FROM_IMAGE=YOUR_PROJECT_IMAGE \
      https://github.com/xoes/dockery-odoo.git#shared:translator

## Tipps for Development

Bind mount some or all of your workdir folders.

**Respect the naming convention to get ~the most~ anything out of it**

_Remember: `addons/090` is your source code_

    docker run -p 80:8069 -v ./src:/opt/odoo/addons/090 odoo/app --dev all

Better use descriptive `docker-compose` files:

    ./docker-compose.yml
    ./docker-compose.override.yml

`docker-compose.override.yml` is a magic file name to override configuration for your machine's local development, you should add it to `.gitignore`.

## Local build

 - Create `.env` file in the repo root.
   This will feed environment variables to `docker-compose`
 - Set `CI_REGISTRY_IMAGE` to the image name you want to use
   It should coincide with the image name in your regestry.
 - Run `docker-compose build`

## CI/CD automated builds

 - This repo is optimized for integrated Gitlab Registry
 - You might want to take `.gitlab-ci.yml` as an example and adapt it to your own CI/CD to create and publish your base images.


# Credits & License

Based on stewardship by:
 - [@blaggacao](https://github.com/blaggacao) ([XOE Solutions](https://xoe.solutions))

License: [LGPL-3](https://www.gnu.org/licenses/lgpl-3.0.en.html)