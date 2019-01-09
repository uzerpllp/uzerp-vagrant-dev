.PHONY: all
all: build

.PHONY: getiso
getiso:
	curl http://www.mirrorservice.org/sites/releases.ubuntu.com/18.04.1/ubuntu-18.04.1.0-live-server-amd64.iso -o box-source/iso/ubuntu-18.04.1.0-live-server-amd64.iso

.PHONY: build
build:
	mkdir -p build
	cp -r box-source/target-files/* build/
	/home/steve/Work/packer/packer build -on-error=ask uzerp-vagrant.json
	tar -zcvf uzerp-dev-1804-box.tar.gz build/*
	rm -rf build

.PHONY: clean
clean:
	rm -f iso/*.iso
	rm -rf build
	rm -rf uzerp-dev-1804-box.tar.gz
	rm -rf packer_cache
	rm -rf uzerp-vagrant
