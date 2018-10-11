Changes
=======

Future (?)
----------
 - force API Extension pattern with click-odoo lib
 - restructure around `:base` and `:devops` image variants
 - rethink `:ci-base` image



0.8.0   (2018-10-11)
--------------------
- first changelog entry
- make repo UX `make` based
- keep dev UX `docker-compose` based

###### More details:

	Changes since HEAD~100:

	  tester:
	   - [FIX] loggingg
	   - [CLEANUP]
	   - [CLEANUP]
	   - [IMP] clarify wording about target mods

	  base:
	   - [IMP] manage locale and set default
	   - [FIX] locale for babel tests
	   - [FIX] locale

	  Other:
	   - [FIX] locale
	   - Update Readme
	   - Create CODE_OF_CONDUCT.md
	   - [IMP] add hugo project page
	   - [FIX] elevate elate
	   - [IMP] website
	   - [FIX] base/Dockerfile
	   - cleanup
	   - [REF] rem base from shared + put in images/
	   - [IMP] Readme
	   - [FIX] xoes -> xoe-labs/xoelabs
	   - [cleanup]
	   - [FIX] filemodes
	   - [FIX] xoes -> xoe-labs
	   - [FIX] marabunta entrypoint scritps
	   - [REF] rem shared stuff (Merge 4d27af9)
	   - [FIX] filemodes (Merge 4d27af9)
	   - [FIX] wrong ODOO_RC value (Merge 4d27af9)
	   - [FIX] export variables (Merge 4d27af9)
	   - [FIX] bash scripts (Merge 4d27af9)
	   - [IMP] execute with 1000 user (default mount uid) (Merge 4d27af9)
	   - [FIX] unbound variable issue (Merge 4d27af9)
	   - [IMP] permit pip install from repos through git (Merge 4d27af9)
	   - [IMP] add pyflame for live tracing (Merge 4d27af9)
	   - [REF] and cleanup for odoo-operator (Merge 4d27af9)
	   - [REF] bash shellcheck + source.d (Merge 4d27af9)
	   - [REF] && [ADD] v11
	   - [FIX] env variable
	   - [IMP] script verbosity
	   - [FIX] entrypoint script
	   - [FIX] Adapt patches to v11
	   - [FIX] re-enable direct cmd `--arg`
	   - [FIX] pacthes application
	   - [IMP] entrypoint control structure
	   - [FIX] umask python3
	   - [IMP] pip phonenumbers is increasingly used
	   - [FIX] migrator to refactoring
	   - [IMP] add master image (based on v11)
	   - [IMP] fix patch naming for windows
	   - [IMP] instruction
	   - [IMP] add enterprise flag
	   - [FIX] doc typo
	   - [IMP] align with odoo version naming
	   - [IMP] correctly source .env in bash
	   - [FIX] doc typo
	   -  Beta: I'm here
	   - [IMP] set executable bits during Dockerfile build
	   - [IMP] shorten readme. tldr.
	   - [FIX] execute bits
	   - [IMP] add support for new Chrome Bworser testing
	   - [IMP] docs for improvements
	   - [IMP] doc: explicit is better than implicit
	   - [IMP] also support js tests screencasts
	   - [FIX] setup chrome users
	   - [IMP] include master in gen_images
	   - [REF] replace build in patches by dynamic remotes
	   - [IMP] quietize apt-get a little
	   - [IMP] quietize curl a little
	   - [IMP] quietize apt-get even more
	   - [IMP] quietize pip
	   - [IMP] quietize pyflame build
	   - [IMP] tab -> ws
	   - [IMP] quietize wget
	   - [IMP] quietize npm
	   - [REF] better folder naming
	   - [FIX] patches 10.0
	   - [FIX] jessie has no ffmpeg
	   - [FIX] 10.0 & 11.0 patch spec
	   - [IMP] remove patch dependency
	   - [IMP] make dev & test build quieter
	   - [IMP] force marabunta in onbuild
	   - [REF] drop lib suuport
	   - [IMP] .env with comments
	   - [IMP] ease instructions
	   - [IMP] add odoo dockery postgres image
	   - [IMP] disclose default admin password
	   - [BUMP] requirements.txt s
	   - [IMP] add usage scenarios
	   - [IMP] clarify wording
	   - [IMP] hint about module load order
	   - [IMP] more concise wording
	   - [IMP] migration controller semantics on scenarios
	   - [IMP] declare PGUSER env variable
	   - [IMP] add gevent server mode
	   - [FIX] bs 4.1.3 for v12
	   - [IMP] UX of scaffold & patches
	   - [IMP] init db UX
	   - [IMP] add og priview images
	   - [IMP] bump elate version (OG)
	   - [DOC] add OG description
	   - [REF] with Makefile
	   - [REF] eaner ci-image
	   - [REF] rem instructions (not needed)
	   - [IMP] docs
	   - [FIX] psql wait-for
	   - [IMP] folder structure
	   - [IMP] be forgiving if applying patches fail
	   - [IMP] don't assign default build arg
	   - [IMP] optimize entrypoint scripts
	   - [IMP] add changelog

	  migrator:
	   - [FIX] marabunta integration
	   - [IMP] entrypoint script
	   - [FIX]

	  Contributors:
	   - Lina Avendano
	   - David Arnold
