# Dockery Odoo

- Odoo DevOps lifecycle tooling based on Docker.
- Meant to ease your life with Odoo.
- Years of experience incorporated, but no Odoo itself.
- Hand crafted for productivity.

**Wether big or small: <a href="https://xoe-labs.github.io/dockery-odoo/" target="_blank">here</a> is where start all.**

## Folders

- `hugo` - the lovely page
- `images` - what you're here for

## The project GAFS
(Generally Accepted Folder Structure) - see [scaffolding repo](https://github.com/xoe-labs/dockery-odoo-scaffold)

```bash
your-project/
 ├── hack/       	# Your life gets easier (TM)
 ├── vendor/
 │   ├── odoo/
 │   │   ├── cc/    # A plain git@github.com:odoo/odoo.git
 │   │   └── ee/    # A plain git@github.com:odoo/enterprise.git
 │   └── .../       # Optionally, additional vendor's repos
 │
 ├── src/           # *Your* folder, develop in here.
 │   ├── module_1/
 │   └── .../
 ├── ...            	# The general suspects (gitignore, etc.)
 ├── .cfg-default.ini	# ... managed at team level, under vcs!
 ├── .cfg-custom.ini	# ... gitignored local config switches!
 ├── .adminpwd			# ... no prod passwords in git, please!
 ├── .marabunta.yml 	# Single source of truth for migrations
 ├── .env           	# Single source of truth for environment
 ├── Dockerfile     	# Single source of truth for image
 ├── docker-compose.yml             # Production akin version
 └── docker-compose.override.yml    # Development akin version
```

## Image Building Sequence

1. Build your projects base image (`:base-*`)
2. Build your projects devops image (`:devops-*`).

\* Use this repo's contexts _or_ fork it and craft your own.


--------

Don't complain about a short readme. :wink:

You are supposed to have started [here](https://github.com/xoe-labs/dockery-odoo).

## Next Steps
- Check the [environment foundation](https://github.com/xoe-labs/dockery-odoo-base)
- Scrutinize the [scaffolding repo](https://github.com/xoe-labs/dockery-odoo-scaffold)
- Check what [`Makefile`](https://github.com/xoe-labs/dockery-odoo-scaffold/blob/master/Makefile) can do for you
- Learn about the [`./.marabunta.yml`](https://github.com/xoe-labs/dockery-odoo-scaffold/blob/master/.marabunta.yml) file, a camptocamp [project](https://github.com/camptocamp/marabunta) that has been [tuned](https://github.com/xoe-labs/marabunta) by folks at [XOE Labs](https://github.com/xoe-labs)
- Get a free, pre-configured CI/CD with [`.gitlab-ci.yml`](https://github.com/xoe-labs/dockery-odoo-scaffold/blob/master/.gitlab-ci.yaml)
- Check the environment "options" in handy [`.env`](https://github.com/xoe-labs/dockery-odoo-scaffold/blob/master/.env) file

# Credits & License

Based on stewardship by:
 - [@blaggacao](https://github.com/blaggacao) ([XOE Solutions](https://xoe.solutions))

License: [LGPL-3](https://www.gnu.org/licenses/lgpl-3.0.en.html)
