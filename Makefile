.PHONY: all
all: build

.PHONY: getiso
getiso:
	curl http://www.mirrorservice.org/sites/releases.ubuntu.com/18.04.1/ubuntu-18.04.1.0-live-server-amd64.iso -o box-source/iso/ubuntu-18.04.1.0-live-server-amd64.iso

.PHONY: build
build:
	mkdir -p build
	cp -r box-source/target-files/* build/
	/home/steve/Work/packer/packer build uzerp-vagrant.json

.PHONY: clean
clean:
	#rm -f iso/*.iso
	rm -rf build
	rm -rf packer_cache
