OS := $(shell uname -s)
image_tag := $(shell cat .build-version)
platform := "linux/arm64,linux/amd64,linux/amd64/v2,linux/riscv64,linux/ppc64le,linux/s390x,linux/386,linux/mips64le,linux/arm/v7,linux/arm/v6"

build-and-push: use-orbstack use-parallel-builder
	docker buildx build --build-arg VERSION=$(image_tag) --platform=$(platform) --push -t jfheinrich/pre-commit:$(image_tag) -t jfheinrich/pre-commit:latest .

build: --use-orbstack --use-parallel-builder --docker-build scout

scout:
	docker scout cves jfheinrich/pre-commit:$(image_tag)

docker-login:
	@[[ "${OS}" != "Darwin" ]] || security unlock-keychain
	@(if [ -z "${DOCKERUSER}" ]; then echo "Please set the environment variable for the docker user!"; else echo "Docker Login: "; docker login -u ${DOCKERUSER}; fi)

docker-logout:
	docker logout

create-parallel-builder:
	docker buildx create --name mybuilder --use

# Private Targets

--docker-build:
	docker build --build-arg VERSION=$(image_tag) -t jfheinrich/pre-commit:$(image_tag) .

--use-parallel-builder:
	docker buildx use mybuilder

--use-orbstack:
	docker context use orbstack
