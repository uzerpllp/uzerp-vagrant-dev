# == Manifest: Provision uzERP base VM
#
# A manifest to provision a uzERP base VM.
#
# === Authors
#
# Steve Blamey <blameys@blueloop.net> Blueloop Ltd.
#
# === Copyright
#
# Copyright 2014 uzERP LLP, unless otherwise noted.
#

# Update the apt-cache
exec { "apt-update":
  command => "/usr/bin/apt-get update",
}

# All package installs ensure that apt-get update has run first
Exec["apt-update"] -> Package <| |>

# Install and configure postgresql
class { 'postgresql::server': 
    listen_addresses => '*',
    ip_mask_allow_all_users => '0.0.0.0/0'
}

# Postgres config/hba rules
$postgres_config_entries = lookup('postgres_configs', {})
create_resources('postgresql::server::config_entry', $postgres_config_entries)

$postgres_hba = lookup('postgres_hba', {})
create_resources('postgresql::server::pg_hba_rule', $postgres_hba)

# Create databases
$postgres_databases = lookup('postgres_databases', {})
create_resources('postgresql::server::database', $postgres_databases)

# Create users/roles
$postgres_roles = lookup('postgres_roles', {})
create_resources('postgresql::server::role', $postgres_roles)

# Grant roles access to databases
$postgres_grants = lookup('postgres_grants', {})
create_resources('postgresql::server::database_grant', $postgres_grants)


#Apache/PHP
#Prefork MPM required for mod_php
class { 'apache': 
  mpm_module => 'prefork',
}

class { '::apache::mod::php': 
}
# Create apache vhosts
$apache_vhosts = hiera_hash('apache_vhosts', {})
create_resources('apache::vhost', $apache_vhosts)


