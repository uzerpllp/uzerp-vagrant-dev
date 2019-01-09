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
	@tar -zcvf uzerp-dev-${VERSION_STR}-box.tar.gz build/*
	@rm -rf build

.PHONY: clean
clean:
	@rm -f box-source/iso/*.iso
	@rm -rf build
	@rm -rf *.tar.gz
	@rm -rf packer_cache
	@rm -rf uzerp-vagrant
