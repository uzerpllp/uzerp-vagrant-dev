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

# Setup uzERP - See: modules/uzerp
class { 'uzerp':
  load_data     => true,
  uzerp_status  => 'uzERP Demo DB Installed',
  uzerp_title   => 'uzERP Vagrant System',
  uzerp_version => 'Box: uzerp-dev-1804',
}

#Apache
class { 'apache':
  default_vhost => false,
  mpm_module => 'prefork',
}

class { '::apache::mod::php':
}

apache::vhost { 'uzerp':
        port => '8080',
        docroot => '/vagrant/uzerp',
        priority => '20',
        options => ['-Indexes', '+FollowSymLinks', '-MultiViews'],
        redirectmatch_status => ['404', '404', '404', '404', '404', '404', '404', '404'],
        redirectmatch_regexp => ['^/conf/.*$', '^/install/.*$', '^/migrations/.*$', '^/plugins/.*$', '^/schema/.*$', '^/vendor/.*$', '^/composer.*$', '^/phinx.*$'],
}

