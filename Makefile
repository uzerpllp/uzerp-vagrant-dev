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

ISO := http://cdimage.ubuntu.com/ubuntu/releases/bionic/release/ubuntu-18.04.1-server-amd64.iso
VERSION_STR := 1804

.PHONY: all
all: build

.PHONY: getiso
getiso:
	@echo Downloading Ubuntu server ISO
	@curl ${ISO} -o box-source/iso/ubuntu-server.iso

.PHONY: build
build:
	@mkdir -p build
	@cp -r box-source/target-files/* build/
	@/home/steve/Work/packer/packer build -on-error=ask uzerp-vagrant.json
	@cp README.md build
	@cp LICENSE build
	@tar -zcvf uzerp-dev-${VERSION_STR}-box.tar.gz build/*
	@rm -rf build

.PHONY: clean
clean:
	@rm -f box-source/iso/*.iso
	@rm -rf build
	@rm -rf *.tar.gz
	@rm -rf packer_cache
	@rm -rf uzerp-vagrant
