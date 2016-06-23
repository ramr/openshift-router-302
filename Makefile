
IMAGE := ramr/maintenance-test
VERSION := v1


all:	build

build:
	docker build -t $(IMAGE) ./
	docker tag $(IMAGE) $(IMAGE):$(VERSION)


run:
	@echo "  - Starting docker container for image $(IMAGE) ... "
	docker run -d -i -t $(IMAGE)

clean:
	#  Shows errors for any containers running using those images.
	@echo "  - Removing docker images for $(IMAGE) ... "
	docker rmi $(IMAGE) || :
	docker rmi $(IMAGE):$(VERSION) || :


tlsconfig:	cacertconfig certconfig
	@echo "  - Generating TLS config ... "


#  Internal targets.
cacertconfig:	config/cacert.pem config/cakey.pem
certconfig:	config/cert.pem config/key.pem

config/cert.pem:	config/key.pem
config/cacert.pem:	config/cakey.pem

config/key.pem:
	./config/generate-tls-config.sh

config/cakey.pem:
	./config/generate-tls-config.sh

.PHONY: 	all build run clean tlsconfig cacertconfig certconfig
