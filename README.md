# [Dockerized Felicity Base Image](https://gitlab.com/devco-odoo/felicity/container_registry)


Highly opinionated image ready to put [Odoo](https://www.odoo.com) inside it,
but **without Odoo**. // Strongly inspired by https://github.com/Tecnativa/docker-odoo-base

## What?

Yes, the purpose of this is to serve as a base for you to build your own Odoo
project, because most of them end up requiring a big amount of custom patches,
merges, repositories, etc. With this image, you have a collection of good
practices and tools to enable your team to have a standard Odoo project
structure.

BTW, we use [Debian][]. It has fast mirrors out of the box. Also in South America.

  [Debian]: https://www.debian.org/

## Why?

Because developing Odoo is hard. You need lots of customizations, dependencies,
and if you want to move from one version to another, it's a pain.

Also because nobody wants Odoo as it comes from upstream, you most likely will
need to add custom patches and addons, at least, so we need a way to put all
together and make it work anywhere quickly.

## How?

You can start working with this straight away with our [scaffolding][].

## Image explained

Basically, every directory you have to worry about is found inside `/opt/odoo`.
This is its structure:

    addons/
        ...
        80-odoo-ee/
        90-odoo-cc/
    odoo/
        ...
    odoo-bin
    .odoorc

Docker boilerplate is living in `/home`. It mainly constructs the config file.

    entrypoint.d/
    conf.d/
    build/
    build.d/  # Your custom build secondary steps are pooled by default

PATH and PYTHONPATH enabled scripts to consider. For convenience.

    ./bin/*    -> /usr/local/bin/
    ./lib/*.py -> /usr/local/lib/python2.7/dist-packages/


## Image usage

Basically, you just need to observe the following folder structure, see [scaffolding][]:
Note that folders cannot be empty. Use an empty `.empty` file instead.

    docker/
        bin/
            .empty
        build.d/
            .empty
        conf.d/
            .empty
        entrypoint.d/
            .empty
        lib/
            .empty
        11-prod.Dockerfile
        12-devel.Dockerfile
        13-runner.Dockerfile
    odoo-cc/
    odoo-ee/
    .env
    01-prod.env
    02-devel.env
    docker-compose.override.yml  # You would typically put this into .gitignore
    docker-compose.override.example  # So we keep an exaple, you can use and update in your org
    docker-compose.yml

The `docker-compose.yml` file:

    services:
      deploy:
        build: {context: ./. , dockerfile: docker/11-prod.Dockerfile}
        image: $CI_REGISTRY_IMAGE
        links: ['psql:db']
        user: odoo
        env_file:
            - 01-prod.env
        develop:
            build: {context: ./. , dockerfile: docker/12-devel.Dockerfile}
            image: $CI_REGISTRY_IMAGE:devel
            links: ['psql:db', 'wdb:wdb']
            ports: ['80:8069', '8072:8072']
            volumes:
              - odoo-data:/var/lib/odoo
              - ./odoo-cc/odoo-bin:/opt/odoo/odoo-bin:ro
              - ./odoo-cc/odoo:/opt/odoo/odoo:ro
              - ./odoo-ee/:/opt/odoo/addons/80-odoo-ee:ro
              - ./odoo-cc/addons:/opt/odoo/addons/90-odoo-cc:ro
              - .:/home/src # Manipulating code from de image (scaffold)
            user: odoo
            env_file:
              - 02-devel.env
            command: ['--dev', 'wdb,reload,qweb,werkzeug,xml']
          runner:
            build: {context: ./. , dockerfile: docker/13-runner.Dockerfile}
            image: $CI_REGISTRY_IMAGE:runner
        ...
        psql
        wdb
        etcetera
        ...
    version: '2'
    volumes:
      odoo-data: {driver: local}
      psql: {driver: local}

After having build de base image and pushed it to your registry, like so...
 - within the base image folder

Linux

    export CI_REGISTRY_IMAGE=[REPLACE-BY-YOUR-BASE-IMAGE-REPO]

    echo "CI_REGISTRY_IMAGE=$CI_REGISTRY_IMAGE" > .env
    docker-compose build
    docker push $CI_REGISTRY_IMAGE:base
    docker push $CI_REGISTRY_IMAGE:latest
    docker push $CI_REGISTRY_IMAGE:devel
    docker push $CI_REGISTRY_IMAGE:runner
    unset CI_REGISTRY_IMAGE

Windows

    set CI_REGISTRY_IMAGE=[REPLACE-BY-YOUR-BASE-IMAGE-REPO]

    echo "CI_REGISTRY_IMAGE=%CI_REGISTRY_IMAGE%" > .env
    docker-compose build
    docker push %CI_REGISTRY_IMAGE%:base
    docker push %CI_REGISTRY_IMAGE%:latest
    docker push %CI_REGISTRY_IMAGE%:devel
    docker push %CI_REGISTRY_IMAGE%:runner
    set CI_REGISTRY_IMAGE=

... you should now build your actual project image
 - within your project folder
 - replace the FROM directives in the templates with your docker repo (the one from above)

Linux

    export CI_REGISTRY_IMAGE=[REPLACE-BY-YOUR-ACTUAL-IMAGE-REPO]

    echo "CI_REGISTRY_IMAGE=$CI_REGISTRY_IMAGE" > .env
    docker-compose build
    docker push $CI_REGISTRY_IMAGE:latest
    docker push $CI_REGISTRY_IMAGE:devel
    docker push $CI_REGISTRY_IMAGE:runner
    unset CI_REGISTRY_IMAGE

Windows

    set CI_REGISTRY_IMAGE=[REPLACE-BY-YOUR-ACTUAL-IMAGE-REPO]

    echo "CI_REGISTRY_IMAGE=%CI_REGISTRY_IMAGE%" > .env
    docker-compose build
    docker push %CI_REGISTRY_IMAGE%:latest
    docker push %CI_REGISTRY_IMAGE%:devel
    docker push %CI_REGISTRY_IMAGE%:runner
    set CI_REGISTRY_IMAGE=

Then you can do:

    docker-compose up devel
    docker-compose run devel shell
    docker-compose run devel scaffold
    ...

You can manage your entire (default) environment throug the `*.env` file, like `10-prod.env`.
"default", because real environment variables superseed those definitions.

Tip: To understand how the magic works, have a closer look at the config.d folder.

Having a closer look at entrypoint.d, you can find out:
 - How addons folders are constructed dynamically in ascending folder name order (hence number prefixing in the COPY directives)
 - How to use rancher/docker secrets in your config.
