IMAGE_NAME=bulletins-app
DOCKER_REPO=profitp0int/devops-engineer-from-scratch-project-315

lint-fix:
	./gradlew spotlessApply

docker-build:
	docker build -t $(IMAGE_NAME) .

docker-run:
	docker run -p 8080:8080 -p 9091:9090 \
		-e SPRING_PROFILES_ACTIVE=dev \
		$(IMAGE_NAME)

docker-push:
	docker tag $(IMAGE_NAME) $(DOCKER_REPO):latest
	docker push $(DOCKER_REPO):latest

docker-stop:
	docker stop $$(docker ps -q --filter ancestor=$(IMAGE_NAME))

docker-clean:
	docker rmi $(IMAGE_NAME)
