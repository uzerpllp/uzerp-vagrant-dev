# == Class: uzERP Configuration
#
# Set-up config.php, create directories and load data
#
# === Authors
#
# Steve Blamey <blameys@blueloop.net> Blueloop Ltd.
#
# === Copyright
#
# Copyright 2014 uzERP LLP, unless otherwise noted.
#

class uzerp (
  # Source base
  $base_dir         = "/vagrant/uzerp",

  # Whether to load sample data and location of the SQL file to import, relative to $base_dir
  $load_data        = true,
  $load_data_path   = "install/database/postgresql/uzerpdemo.sql",
  $db_name          = "uzerp",
  $db_password      = "xxx",
        
  # Config file variables
  $uzerp_status     = "uzERP Demo Install",
  $uzerp_title      = "uzERP Vagrant System",
  $uzerp_message    = "",
  $uzerp_version    = "",
    
) {

  file {"${base_dir}/conf/config.php":
    ensure  => file,
    content => template('uzerp/config.erb'),
  }

  file {"${base_dir}/data/company1":
    ensure  => directory,   
  }

  file {"${base_dir}/data/templates_c":
    ensure  => directory,   
  }

  file {"${base_dir}/data/tmp":
    ensure  => directory,   
  }
  
  file {"${base_dir}/data/resource_cache":
    ensure  => directory,   
  }
    
  # Load data - clean and reload on each vagrant provision
  if $load_data {
    exec { 'load_db':
      command => "sudo -u postgres pg_restore -d uzerp ${base_dir}/${load_data_path} >> /dev/null",
      path    => '/usr/bin:/bin/',
      # trying to stop the exec running if the database has tables, but this doesn't work - YET!
      #unless  => '/bin/bash -c if [ "$(su -l postgres -c psql -d uzerp -c \\dt)" = "No relations found." ]; then exit 0; else exit 1; fi'
    }
  }
}
