IMAGE_NAME=devops-engineer-from-scratch-project-315
DOCKER_REPO=ghcr.io/dobro10k2/devops-engineer-from-scratch-project-315

# Get short git commit sha
GIT_SHA := $(shell git rev-parse --short HEAD)

.PHONY: docker-build docker-tag docker-push docker-run docker-stop docker-clean

lint-fix:
	./gradlew spotlessApply

docker-build:
	docker build -t $(IMAGE_NAME) .

docker-tag:
	docker tag $(IMAGE_NAME) $(DOCKER_REPO):latest
	docker tag $(IMAGE_NAME) $(DOCKER_REPO):$(GIT_SHA)

docker-push:
	docker push $(DOCKER_REPO):latest
	docker push $(DOCKER_REPO):$(GIT_SHA)

docker-publish: docker-build docker-tag docker-push

docker-run:
	docker run -p 8080:8080 -p 9090:9090 \
		-e SPRING_PROFILES_ACTIVE=dev \
		$(IMAGE_NAME)

docker-stop:
	docker stop $$(docker ps -q --filter ancestor=$(IMAGE_NAME))

docker-clean:
	docker rmi $(IMAGE_NAME)

ansible:
	ansible-playbook playbook.yml -e docker_tag=$(or $(docker_tag),$(GIT_SHA)) --ask-vault-pass

deploy:
	ansible-playbook playbook.yml -e docker_tag=$(or $(docker_tag),$(GIT_SHA)) --tags deploy --ask-vault-pass
