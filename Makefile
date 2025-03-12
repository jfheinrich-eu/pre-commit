image_tag := 1.0.0

build-and-push:
	docker buildx build --platform=linux/amd64,linux/arm64 --push -t "\[jfheinrich/pre-commit:$(image_tag),jfheinrich/pre-commit:latest\]" .

