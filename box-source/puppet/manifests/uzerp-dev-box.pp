# == Manifest: Provision uzERP base VM
#
# A manifest to provision a uzERP base VM.
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

# Install and configure postgresql
class { 'postgresql::server':
    listen_addresses => '*',
    ip_mask_allow_all_users => '0.0.0.0/0'
}

postgresql::server::config_entry { 'log_destination':
    value => 'stderr',
}

postgresql::server::config_entry { 'logging_collector':
    value => 'on',
}

postgresql::server::config_entry { 'log_directory':
    value => 'pg_log',
}

postgresql::server::config_entry { 'log_min_error_statement':
    value => 'error',
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

postgresql::server::database { 'uzerp':
        owner => 'sysadmin',
        encoding => 'UTF8',
        locale => 'en_GB.UTF-8',
}

postgresql::server::role { 'www-data':
        password_hash => 'md586ab55009873f76272464bd71c3fad8e',
}

postgresql::server::role { 'sysadmin':
        password_hash => 'md5d6b4c0eace7f2dc0f34f00a75b02743b',
        superuser => true,
        createdb => true,
        createrole => true,
}

postgresql::server::role { 'readonly':
        password_hash => 'md5efab781424b23fbfd7ff8d21424d5be0',
}

postgresql::server::role { 'ooo-data':
        password_hash => 'md538c9687d34994094b696f388b4815800',
}

postgresql::server::database_grant { 'www-data-uzerp':
        privilege => 'ALL',
        db => 'uzerp',
        role => 'www-data',
}

postgresql::server::database_grant { 'sysadmin-uzerp':
        privilege => 'ALL',
        db => 'uzerp',
        role => 'sysadmin',
}

postgresql::server::database_grant { 'readonly-uzerp':
        privilege => 'CONNECT',
        db => 'uzerp',
        role => 'readonly',
}

postgresql::server::database_grant { 'ooo-data-uzerp':
        privilege => 'CONNECT',
        db => 'uzerp',
        role => 'ooo-data',
}


#Apache/PHP
#Prefork MPM required for mod_php
class { 'apache':
  mpm_module => 'prefork',
}

class { '::apache::mod::php':
}

class {'xdebug':
  xdebug_enable => true,
  require => Class["apache"],
}

