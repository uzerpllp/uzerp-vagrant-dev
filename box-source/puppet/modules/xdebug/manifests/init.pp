# == Class: xdebug
#
# Install xdebug for remote PHP debugging
#
# === Authors
#
# Steve Blamey <blameys@blueloop.net> Blueloop Ltd.
#
# === Copyright
#
# Copyright 2014 uzERP LLP, unless otherwise noted.
#

class xdebug (
  $xdebug_enable = false,
){
  if $xdebug_enable {
      package { 'php-xdebug':
        ensure => 'installed',
      }
      
      file {"/etc/php/7.2/apache2/conf.d/20-xdebug.ini":
        ensure  => file,
        content => template('xdebug/xdebug.erb'),
        notify  => Service['apache2'],
      }
  }

}
