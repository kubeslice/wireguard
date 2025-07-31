TAG ?= latest
IMAGE_REGISTRY ?= ghcr.io/kube-slice

.PHONY: docker-build
docker-build: ## Build docker image with the manager.
	docker buildx create --name container --driver=docker-container || true
	docker build --builder container --platform linux/amd64,linux/arm64 -t ${IMAGE_REGISTRY}/wireguard-server.alpine:${TAG} -f server-wireguard.dockerfile .
	docker build --builder container --platform linux/amd64,linux/arm64 -t ${IMAGE_REGISTRY}/wireguard-client.alpine:${TAG} -f client-wireguard.dockerfile .

.PHONY: docker-push
docker-push: ## Push docker image with the manager.
	docker buildx create --name container --driver=docker-container || true
	docker build --push --builder container --platform linux/amd64,linux/arm64 -t ${IMAGE_REGISTRY}/wireguard-server.alpine:${TAG} -f server-wireguard.dockerfile .
	docker build --push --builder container --platform linux/amd64,linux/arm64 -t ${IMAGE_REGISTRY}/wireguard-client.alpine:${TAG} -f client-wireguard.dockerfile .
