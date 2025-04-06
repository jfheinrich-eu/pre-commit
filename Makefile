ifeq ($(OS),)
	OS := $(shell uname -s)
endif
ifeq ($(image_tag),)
	image_tag := $(shell cat .build-version)
endif
ifeq ($(build_date),)
	build_date := $(shell date --iso-8601=seconds)
endif
ifeq ($(GITHUB_REPOSITORY),)
	repository := jfheinrich-dev/pre-commit
else
	repository := $(GITHUB_REPOSITORY)
endif
ifeq ($(CI_COMMIT_REF_SLUG),)
	CI_COMMIT_REF_SLUG := $(GITHUB_REF)
endif
ifeq ($(CI_COMMIT_SHORT_SHA),)
	CI_COMMIT_SHORT_SHA := $${GITHUB_SHA:0:8}
endif

platform := "linux/arm64,linux/amd64,linux/amd64/v2,linux/riscv64,linux/ppc64le,linux/s390x,linux/386,linux/mips64le,linux/arm/v7,linux/arm/v6"

build-and-push: use-orbstack use-parallel-builder --docker-buildx

build: --use-orbstack --use-parallel-builder --docker-build scout

ci-build:
	@echo "Building for branch: ${CI_COMMIT_REF_SLUG}:${CI_COMMIT_SHORT_SHA}"
	@[[ "${CI}X" = "X" ]] || docker build --build-arg BUILD_DATE="$(build_date)" --build-arg VERSION="${CI_COMMIT_REF_SLUG}.${CI_COMMIT_SHORT_SHA}" -t ${CI_PSONO_REGISTRY}/$(repository):build .
	@[[ "${CI}X" = "X" ]] || docker push ${CI_PSONO_REGISTRY}/$(repository):build

ci-build-staging:
	@[[ "${CI}X" = "X" ]] || echo "Building for branch: ${CI_COMMIT_REF_SLUG}:${CI_COMMIT_SHORT_SHA}"
	@[[ "${CI}X" = "X" ]] || docker build --build-arg BUILD_DATE="$(build_date)" --build-arg VERSION="${CI_COMMIT_REF_SLUG}.${CI_COMMIT_SHORT_SHA}" -t ${CI_PSONO_REGISTRY}/$(repository):${CI_COMMIT_REF_SLUG} .
	@[[ "${CI}X" = "X" ]] || docker tag ${CI_PSONO_REGISTRY}/$(repository):${CI_COMMIT_REF_SLUG} ${CI_PSONO_REGISTRY}/$(repository):${CI_COMMIT_SHORT_SHA}
	@[[ "${CI}X" = "X" ]] || docker push ${CI_PSONO_REGISTRY}/$(repository):${CI_COMMIT_REF_SLUG}
	@[[ "${CI}X" = "X" ]] || docker push ${CI_PSONO_REGISTRY}/$(repository):${CI_COMMIT_SHORT_SHA}

ci-build-and-push: --docker-buildx

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

--docker-buildx:
	docker buildx build --build-arg BUILD_DATE="$(build_date)" --build-arg VERSION=$(image_tag) --platform=$(platform) --push -t jfheinrich/pre-commit:$(image_tag) -t jfheinrich/pre-commit:latest .

--docker-build:
	docker build --build-arg VERSION=$(image_tag) --build-arg BUILD_DATE="$(build_date)" -t jfheinrich/pre-commit:$(image_tag) .

--use-parallel-builder:
	docker buildx use mybuilder

--use-orbstack:
	docker context use orbstack
