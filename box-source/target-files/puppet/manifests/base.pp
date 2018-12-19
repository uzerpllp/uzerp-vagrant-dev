# == Manifest: Provision uzERP development environment in Vagrant
#
# A manifest to provision the uzERP development environment in a Vagrant box.
# This is quick and dirty stuff to get things moving. Later, it will be
# paramterised and fed by hiera yaml.
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
# Listen on all interfaces and allow any user to connect from outside the VM (pgAdmin/ODBC access)
class { 'postgresql::server': 
  listen_addresses        => '*',
  ip_mask_allow_all_users => '0.0.0.0/0'
}

# Allow some users to connect without a password
postgresql::server::pg_hba_rule { 'local trust':
  description => "local trust",
  type => 'host',
  database => 'all',
  user => 'all',
  address => '127.0.0.1/32',
  auth_method => 'trust',
  order => '000',
}

# Setup uzERP - See: modules/uzerp
class { 'uzerp':
  load_data     => true,
  uzerp_status  => 'uzERP Demo Install',
  uzerp_title   => 'uzERP Vagrant System',
  uzerp_version => 'UZERP-DEV-BOX',
}

class {'xdebug':
  xdebug_enable => true,
}

#Apache
class { 'apache': 
  mpm_module => 'prefork',
  default_vhost => false,
}

class { '::apache::mod::php': }

apache::vhost { 'localhost':
  port    => '8080',
  docroot => '/vagrant/uzerp',
}

