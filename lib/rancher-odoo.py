#!/usr/bin/env python

import click
import hammock


@click.group()
@click.option('--rancher-url', envvar='RANCHER_URL', required=True,
              help='Configures the rancher API-URL.')
@click.option('--rancher-key', envvar='RANCHER_ACCESS_KEY', required=True,
              help='Configures the rancher access key.')
@click.option('--rancher-secret', envvar='RANCHER_SECRET_KEY', required=True,
              help='Configures the rancher api secret.')
@click.version_option('1.0')
@click.pass_context
def cli(ctx, rancher_url, rancher_key, rancher_secret):
    """Rancher-odoo is a command line utility tool that groups wrapper for
    odoo specific operations that are not supported by the native Rancher CLI.
    """
    ctx.obj = hammock.Hammock(rancher_url, auth=(rancher_key, rancher_secret), append_slash=True)


pass_rancher = click.make_pass_decorator(hammock.Hammock)


@click.group()
@click.argument('loadbalancer_id', required=True, metavar='<ID>')
@pass_rancher
def lb(rancher, loadbalancer_id):
    """Loadbalancer operations on a specified loablalancer.

    <ID>: Id of the specified Loadbalancer (example: 1s624)"""
    rancher.lb_json = rancher.loadbalancerservices(loadbalancer_id).GET().json()


cli.add_command(lb)


def _clean_rules(rules, hostname, service_id):
    return [rule for rule in rules if
            (rule['hostname'] != hostname and rule['serviceId'] != service_id)]


@click.command()
@click.argument('hostname', required=True, metavar='<hostname>')
@click.argument('service_id', required=True, metavar='<ID>')
@pass_rancher
def serve(rancher, hostname, service_id):
    """Setup Odoo + Longpolling forwarding rules on their default ports (8069/8072).

    \b
    <hostname>: Hostname to be served, include schema.
    <ID>:       Id of the target service (example: 1s624)"""
    rancher.srv_json = rancher.services(service_id).GET().json()
    rancher.stck_json = rancher.stacks(rancher.srv_json['stackId']).GET().json()
    rancher.lb_json['lbConfig']['portRules'] = _clean_rules(rancher.lb_json['lbConfig']['portRules'], hostname, service_id)
    rancher.lb_json['lbConfig']['portRules'].extend([{
        "backendName": None,
        "hostname": hostname,
        "path": "",
        "selector": None,
        'priority': 1,
        'serviceId': service_id,
        'protocol': 'http',
        'type': 'portRule',
        'sourcePort': 80,
        'targetPort': 8069
    }, {
        "backendName": None,
        "hostname": hostname,
        "path": "",
        "selector": None,
        'priority': 1,
        'serviceId': service_id,
        'protocol': 'http',
        'type': 'portRule',
        'sourcePort': 8072,
        'targetPort': 8072
    }])
    rancher.loadbalancerservices(rancher.lb_json['id']).PUT(params=rancher.lb_json)
    click.echo('Loadbalancer {lb_name} is now serving Odoo and Longpolling on '
               'host {hostname} to service {srv_name} in stack {stck_name}!'.format(
                   hostname=hostname,
                   lb_name=rancher.lb_json['name'],
                   srv_name=rancher.srv_json['name'],
                   stck_name=rancher.stck_json['name']
               ))


lb.add_command(serve)


@click.command()
@click.argument('hostname', required=True, metavar='<hostname>')
@click.argument('service_id', required=True, metavar='<ID>')
@pass_rancher
def unserve(rancher, hostname, service_id):
    """Tear down Odoo + Longpolling forwarding rules. Only rules
    where hostname *and* ID are exact matches are destroyed.

    \b
    <hostname>: Hostname to be unserved, include schema.
    <ID>:       Id of the target service (example: 1s624)"""
    rancher.srv_json = rancher.services(service_id).GET().json()
    rancher.stck_json = rancher.stacks(rancher.srv_json['stackId']).GET().json()
    rancher.lb_json['lbConfig']['portRules'] = _clean_rules(rancher.lb_json['lbConfig']['portRules'], hostname, service_id)
    rancher.loadbalancerservices(rancher.lb_json['id']).PUT(params=rancher.lb_json)
    click.echo('Loadbalancer {lb_name} has stopped serving Odoo and Longpolling on '
               'host {hostname} to service {srv_name} in stack {stck_name}!'.format(
                   hostname=hostname,
                   lb_name=rancher.lb_json['name'],
                   srv_name=rancher.srv_json['name'],
                   stck_name=rancher.stck_json['name']
               ))


lb.add_command(unserve)

if __name__ == '__main__':
    cli()
