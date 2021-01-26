IMAGE ?= supply-chain-ink
IMAGE_DEV ?= $(IMAGE)-dev

DOCKER ?= podman #you can use "podman" as well

.PHONY: init
init:
	rustup self update
	rustup update nightly
	rustup target add wasm32-unknown-unknown --toolchain nightly
	rustup default nightly
	rustup component add rust-src
	cargo install --git https://github.com/paritytech/cargo-contract cargo-contract --force

.PHONY: build
build:
	cargo contract build

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
	@$(DOCKER) run --net=host -it --rm --entrypoint /bin/ash $(IMAGE_DEV)
