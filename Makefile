IMAGE ?= supply-chain-ink
IMAGE_DEV ?= $(IMAGE)-dev

DOCKER ?= docker #you can use "podman" as well

.PHONY: init
init:
	rustup self update
	rustup update nightly
	rustup +nightly component add rust-src
	rustup target add wasm32-unknown-unknown --toolchain nightly
	cargo install --git https://github.com/paritytech/cargo-contract cargo-contract --features extrinsics --force

.PHONY: build
build:
	cargo +nightly build contract build

.PHONY: release
release:
	@$(DOCKER) build --no-cache --squash -t $(IMAGE) .

.PHONY: dev-docker-build
dev-docker-build:
	@$(DOCKER) build -t $(IMAGE_DEV) .

.PHONY: dev-docker-run
dev-docker-run:
	@$(DOCKER) run --net=host -it --rm $(IMAGE_DEV) --dev --tmp

.PHONY: dev-docker-inspect
dev-docker-inspect:
	@$(DOCKER) run --net=host -it --rm --entrypoint /bin/bash $(IMAGE_DEV)
