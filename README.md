# Vagrant Development Environment for uzERP

This repository provides files required to build the uzERP [Vagrant](https://www.vagrantup.com/) Development Environment with [Packer](https://www.packer.io/).

## Packer Build

> Note: you can download a pre-built environment from ```https://www.uzerp.com/downloads/uzerp-dev-1804-box.tar.gz```,
> then follow the instructions below, [Using the Vagrant box for uzERP Development](#using-the-vagrant-box-for-uzerp-development).

Clone the git repo:

```
$ mkdir uzerp-packer
$ cd uzerp-packer
$ git clone https://github.com/uzerpllp/uzerp-packer-dev.git
```

Download the Ubuntu server ISO file and Build:

```
$ make getiso
$ make
```

The output, uzerp-dev-1804-box.tar.gz, contains the Vagrant box, puppet modules/manifests, and utility files.

## Using the Vagrant box for uzERP Development

### Requirments

To use the uzERP development environment, you will need the following installed:

* Virtualbox
* Vagrant
* git
* puppet
* npm

### Setup Vagrant and uzERP

Create a directory for uzERP development:

```
$ mkdir uzerp-dev
$ cd uzerp-dev
```

Download the vagrant box and provisioner files:

```
$ wget https://www.uzerp.com/downloads/uzerp-dev-1804-box.tar.gz -P /tmp
$ tar -xvf /tmp/uzerp-dev-1804-box.tar.gz --strip 1
```

Clone the uzERP git repo:

```
$ git clone https://github.com/uzerpllp/uzerp.git
```

Import the box and configure Vagrant:

```
$ vagrant box add uzerp-dev-1804.box --name uzerp-dev-1804
$ vagrant init uzerp-dev-1804
```

Provision the Vagrant machine:

```
$ vagrant up --provider virtualbox
```

Build uzERP CSS and JS with gulp:

```
$ cd uzerp
$ npm install
$ npm run gulp

```

Install PHP dependencies with Composer:

```
$ vagrant ssh
$ cd /vagrant/uzerp
$ composer install
```

Apply database migrations with Phinx:


```
$ php vendor/bin/phinx migrate -e development
```

Visit ```http://localhost:8080``` in your browser. You can login with Username: ```admin```, Password ```admin```.

### Access Postgresql

You can use a GUI tool, like PHPAdminIII, to access Postgresql on port ```5432``` on ```localhost``` using the following credentials:

```
Role: sysadmin, Password: xxx
Role: readonly, Password: data123
```
## Copyright and License

Copyright 2018 uzERP LLP, unless otherwise stated.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
