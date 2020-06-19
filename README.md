# Dockery Odoo

Expands on conventionalization over [`dockery-odoo-base` images](https://github.com/OdooOps/dockery-odoo-base).

If you like convention, keep on reading. If you don't, use bare `dockery-odoo-base` images, instead.

- Odoo DevOps lifecycle tooling based on Docker.
- Meant to ease your life with Odoo.
- Years of experience incorporated, but no Odoo itself.
- Hand crafted for productivity.

**Wether big or small: <a href="https://odooops.github.io/dockery-odoo/" target="_blank">here</a> is where start all.**

## General Characteristics

- Two image variants: `prod` (slim) & `devops` (convenience)
- Consistent Dockery Odoo conventionalization (over configuration)
- Helpful code comments all around

## Features - Production image

- Conventionalized extra runtime libraries (none at the moment)
- Conventionalized `ONBUILD` forward-enforcing folder layout (this is
  true conventionalism "dictatorship") \*
- Conventionalized patch tooling for in-tree or remotely served patches \*\*
- Conventionalized extension mechanism (`entrypoint.d`, `bin.d`)

\* great fit for magical & simple to maintain downstream tooling
\*\* TODO: This needs some conceptual thought: move to `devops` only?

## Features - Devops image

- Conventionalized devops environment
- Conventionalized in-container workdir, that tools can safely rely upon
- Conventionalized general debian devops tools (`mtr`, `net-tools`, etc.)
- Conventionalized python devops tools (`dodoo`, linters, etc.)

## Layered projects

There is a magic trick inherited from `dockery-odoo-base` images: Both,
`ODOO_VENDOR` and `ODOO_SRC`, can accomodate a space separated list of strings
values. The `dockery-base-image` entry script then sorts them and adds them to
the addon path in alphanumerical order.

Hence you can forward-enforce in you project:
```Dockerfile
ONBUILD ENV ODOO_BASEPATH  "/opt/odoo8"                              # 9 -> 8
ONBUILD ENV ODOO_VENDOR    "${ODOO_VENDOR} ${ODOO_BASEPATH}/vendor"  # append
ONBUILD ENV ODOO_SRC       "${ODOO_SRC}    ${ODOO_BASEPATH}/src"     # append

ONBUILD COPY --chown=odoo:odoo  vendor    "${ODOO_BASEPATH}/vendor"
ONBUILD COPY --chown=odoo:odoo  src       "${ODOO_BASEPATH}/src"
```

The [scaffolding repo](https://github.com/OdooOps/dockery-odoo-scaffold)
provides you with an example Dockerfile which makes use of this technique.

## Code Generators

**tl;dr**: only ever modify `_spec-*`, then run `just regenerate`; commit both actions separatly.

- Specfifications are merged into target folders.
- The in the target folder, `Dockerfiles.##.tmpl` are sorted, merged into `Dockerfile` & finally removed.

This repo uses code generators, because:
- they ease maintenance
- they reduce errors
- they present complete and self-contained build specifications to the reader

## Task Runner

As a task runner, we use [`just`](https://github.com/casey/just), it's _just_ better in every aspect than `make`. But you have to [install it](https://github.com/casey/just#installation). _And_ it work's on windows, if you have `bash` installed, since we just use bash. \*

\* Pro Tipp: Install shell completions, they'll get you a long way.

The `justfile` contains a series of convenience receipes: discover the current available ones with `just --list`.


--------

## Further Information
- Scuritinze those [`dockery-odoo-base` images](https://github.com/OdooOps/dockery-odoo-base)
- Make concrete use of `dockery-odoo` images with the [scaffolding repo](https://github.com/OdooOps/dockery-odoo-scaffold)

# Credits & License

Based on stewardship by:
 - [@blaggacao](https://github.com/blaggacao)
 - [@ygol](https://github.com/ygol)

License: [LGPL-3](https://www.gnu.org/licenses/lgpl-3.0.en.html)
