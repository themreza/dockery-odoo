#!/usr/bin/env python
"""
Usage: odoo-get-changed-modules -c [ref] [--excluded module1,module2,...] [--included module1,module2,...] path1 [path2 ...]
Given a list  of modules which where changed against the referenc commit.
"""

from __future__ import print_function
import ast
import os
import sys
import subprocess

MANIFEST_FILES = [
    '__manifest__.py',
    '__odoo__.py',
    '__openerp__.py',
    '__terp__.py',
]


def cmd_run(cmd):
    try:
        res = subprocess.check_output(cmd)
    except subprocess.CalledProcessError:
        res = None
    if isinstance(res, basestring):
        res = res.strip('\n')
    return res


def is_module(path):
    """return False if the path doesn't contain an odoo module, and the full
    path to the module manifest otherwise"""

    if not os.path.isdir(path):
        return False
    files = os.listdir(path)
    filtered = [x for x in files if x in (MANIFEST_FILES + ['__init__.py'])]
    if len(filtered) == 2 and '__init__.py' in filtered:
        return os.path.join(
            path, next(x for x in filtered if x != '__init__.py'))
    else:
        return False


def is_installable_module(path):
    """return False if the path doesn't contain an installable odoo module,
    and the full path to the module manifest otherwise"""
    manifest_path = is_module(path)
    if manifest_path:
        manifest = ast.literal_eval(open(manifest_path).read())
        if manifest.get('installable', True):
            return manifest_path
    return False


def get_modules(path):

    # Avoid empty basename when path ends with slash
    if not os.path.basename(path):
        path = os.path.dirname(path)

    res = []
    if os.path.isdir(path):
        res = [x for x in os.listdir(path) if is_installable_module(os.path.join(path, x))]
        if not res:
            for subdir in os.listdir(path):
                if subdir == '.git':
                    continue
                res += get_modules(os.path.join(path, subdir))
    return res


def get_modules_changed(base_ref='origin/master'):
    '''Get modules changed from git diff-index {base_ref}
    :param base_ref: branch or remote/branch or sha to compare
    :return: List of unique modules changed
    '''
    if '/' in base_ref:
        # Gitlab narrows down the fetching refspec, so we patch it temporarily
        original = cmd_run(['git', 'config', '--get', 'remote.origin.fetch'])
        base_ref_split = base_ref.split('/', 1)
        base_ref_remote = base_ref_split[0]
        base_ref_branch = base_ref_split[1]
        cmd_run([
            'git', 'config', 'remote.origin.fetch',
            '+refs/heads/{base_ref_branch}:refs/remotes/{base_ref_remote}/{base_ref_branch}'.format(**locals())
        ])
        cmd_run(['git', 'fetch'] + base_ref_split)
        cmd_run(['git', 'config', 'remote.origin.fetch', original])
    res = cmd_run(['git', 'diff-index', '--name-only', '--cached', base_ref])
    items_changed = res.split('\n') if res else []
    changed_module = []
    while items_changed:
        item = items_changed.pop(0)
        if '/' not in item:
            continue
        if is_module('/'.join(item.split('/')[:-1])):
            changed_module.append(item.split('/')[-2])
        else:
            items_changed.append(item.split('/')[:-1])
    return changed_module


def main(argv=None):
    if argv is None:
        argv = sys.argv
    params = argv[1:]
    if not params or len(params) < 3 or params.pop(0) != '-c':
        print(__doc__)
        return 1
    excluded = included = []
    base_ref = params.pop(0)
    for i, v in enumerate(params):
        if v == '--exclude':
            excluded = params[i + 1].split(',')

        if v == '--include':
            included = params[i + 1].split(',')
    for i, v in enumerate(params):
        if v == '--exclude':
            params.pop(i)  # The exclude flag
            params.pop(i)  # The exclude modules
    for i, v in enumerate(params):
        if v == '--include':
            params.pop(i)  # The include flag
            params.pop(i)  # The include modules
    modules_changed = get_modules_changed(base_ref)
    modules = [get_modules(path) for path in params]
    modules = [x for l in modules for x in l]  # flatten list of lists

    res = list(set(modules) & set(modules_changed) - set(excluded) | set(included))
    print(','.join(res))


if __name__ == "__main__":
    sys.exit(main())
