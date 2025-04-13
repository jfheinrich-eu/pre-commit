ifeq ($(OS),)
	OS := $(shell uname -s)
endif
ifeq ($(image_tag),)
	image_tag := $(shell cat .build-version)
endif
ifeq ($(build_date),)
	build_date := $(shell date --iso-8601=seconds)
endif
ifeq ($(image),)
	image := ghcr.io/jfheinrich-eu/pre-commit
endif

platform := "linux/arm64,linux/amd64,linux/amd64/v2,linux/riscv64,linux/ppc64le,linux/s390x,linux/386,linux/mips64le,linux/arm/v7,linux/arm/v6"

build-and-push: use-orbstack use-parallel-builder --docker-buildx

build: --use-orbstack --use-parallel-builder --docker-build scout

scout:
	docker scout cves $(image):$(image_tag)

docker-login:
	@[[ "${OS}" != "Darwin" ]] || security unlock-keychain
	@(if [ -z "${DOCKERUSER}" ]; then echo "Please set the environment variable for the docker user!"; else echo "Docker Login: "; docker login -u ${DOCKERUSER}; fi)

docker-logout:
	docker logout

create-parallel-builder:
	docker buildx create --name mybuilder --use

# Private Targets

--docker-buildx:
	docker buildx build --build-arg BUILD_DATE="$(build_date)" --build-arg VERSION=$(image_tag) --platform=$(platform) --push -t $(image):$(image_tag) -t $(image):latest .

--docker-build:
	docker build --build-arg VERSION=$(image_tag) --build-arg BUILD_DATE="$(build_date)" -t $(image):$(image_tag) .

--use-parallel-builder:
	docker buildx use mybuilder

--use-orbstack:
	docker context use orbstack
