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
# === Copyright and License
#
# Copyright 2018 uzERP LLP, unless otherwise noted.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

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

