#!/bin/bash

sudo -u postgres dropdb demo
sudo su - postgres -c "createdb --owner='postgres' --template=template0 --encoding 'UTF8' --locale=en_GB.UTF-8  'demo'"
sudo su - postgres -c "pg_restore --dbname=demo /vagrant/uzerp/install/database/postgresql/uzerp-demo-dist.sql"
php /vagrant/uzerp/vendor/bin/phinx migrate -e demo -c /vagrant/utils/phinx-dumps.yml
sudo su - postgres -c "pg_dump --clean --dbname=demo -F c > /vagrant/uzerp/install/database/postgresql/uzerp-demo-dist.sql"
sudo -u postgres dropdb demo

sudo -u postgres dropdb starter
sudo su - postgres -c "createdb --owner='postgres' --template=template0 --encoding 'UTF8' --locale=en_GB.UTF-8  'starter'"
sudo su - postgres -c "pg_restore --dbname=starter /vagrant/uzerp/install/database/postgresql/uzerp-starter-dist.sql"
php /vagrant/uzerp/vendor/bin/phinx migrate -e starter -c /vagrant/utils/phinx-dumps.yml
sudo su - postgres -c "pg_dump --clean --dbname=starter -F c > /vagrant/uzerp/install/database/postgresql/uzerp-starter-dist.sql"
sudo -u postgres dropdb starter

sudo -u postgres dropdb base
sudo su - postgres -c "createdb --owner='postgres' --template=template0 --encoding 'UTF8' --locale=en_GB.UTF-8  'base'"
sudo su - postgres -c "pg_restore --dbname=base /vagrant/uzerp/install/database/postgresql/uzerp-base-dist.sql"
php /vagrant/uzerp/vendor/bin/phinx migrate -e base -c /vagrant/utils/phinx-dumps.yml
sudo su - postgres -c "pg_dump --clean --dbname=base -F c > /vagrant/uzerp/install/database/postgresql/uzerp-base-dist.sql"
sudo -u postgres dropdb base

