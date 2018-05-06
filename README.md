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

Basically, every directory you have to worry about is `/opt/odoo`.
In your project, this should be it's structure:

    addons/
        10-my-addons/
        ...
        80-odoo-ee/
        90-odoo-cc/
    odoo/
        ...
    odoo-bin
    .odoorc

Docker boilerplate is living in `/`.

PATH and PYTHONPATH enabled scripts to consider. For convenience.

    ./bin/*    -> /usr/local/bin/
    ./lib/*.py -> /usr/local/lib/python2.7/dist-packages/

### Note on `chmod +x`
We avoid cluttering Dockerfiles with `RUN chmod +x` files through setting the exeuting bit within git. After adding files to the index, just do:
    
    # Do not complain on .empty files (Bash only)
    shopt -s dotglob
    git update-index --chmod=+x \
        base/bin/* \
        base/entrypoint.d/* \
        base/lib/* \
        tester/lib/* \
        translator/lib/*
    shopt -u dotglob

Don't foget to set `git config core.filemode true` before cloning.

This unfortunately only works on linux computers. You need to add `RUN chmod +x` on windows machines.

## Image usage

**To create your project's Dockerfile:**


    # .docker/Dockerfile
    ARG  FROM_IMAGE=xoes/dockery-odoo
    FROM ${FROM_IMAGE}

    # Load framework
    COPY odoo-cc/odoo-bin  /opt/odoo/odoo-bin
    COPY odoo-cc/odoo      /opt/odoo/odoo

    # Load enterprise and community addons
    COPY odoo-ee           /opt/odoo/addons/80-odoo-ee
    COPY odoo-cc/addons    /opt/odoo/addons/90-odoo-cc
    
    # Your addons
    COPY addons1           /opt/odoo/addons/70-addons1
    COPY addons2           /opt/odoo/addons/60-addons2

- Loading is done in alfanumeric ascending order of your addons folder name
- This is useful if you need to override entire modules (first loaded = used)

**To build your project's image (`odoo/app`):**

    docker build --tag odoo/app .

or with your custom base image

    docker build --tag odoo/app --build-arg FROM_IMAGE=YOUR_PROJECT_BASE_IMAGE .

for development, it's recomended to override the current addon folder...

    docker run -p 80:8069 -v ./addons1:/opt/odoo/addons/70-addons1 odoo/app --dev all

or better use descriptive `docker-compose` files:

    ./docker-compose.yml
    ./docker-compose.override.yml

`docker-compose.override.yml` is a magic file name to override configuration for your local development, you should add it to `.gitignore`.


**To build your project's dev-container:**

    docker build --build-arg FROM_IMAGE=YOUR_PROJECT_IMAGE https://github.com/xoes/dockery-odoo.git#shared:dev

**To build your project's tester:**

    docker build --build-arg FROM_IMAGE=YOUR_PROJECT_IMAGE https://github.com/xoes/dockery-odoo.git#shared:tester

**To build your project's migrator:**

    docker build --build-arg FROM_IMAGE=YOUR_PROJECT_IMAGE https://github.com/xoes/dockery-odoo.git#shared:migrator

**To build your project's translator:**

    docker build --build-arg FROM_IMAGE=YOUR_PROJECT_IMAGE https://github.com/xoes/dockery-odoo.git#shared:translator

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