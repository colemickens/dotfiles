### Docker completion
DOCKER_VERSION="v1.12.0"
DOCKER_COMPLETION_FILE="$HOME/.zsh/completions/_docker"
[[ -f "${DOCKER_COMPLETION_FILE}" ]] || {
	curl -L "https://raw.githubusercontent.com/docker/docker/${DOCKER_VERSION}/contrib/completion/zsh/_docker" > "${DOCKER_COMPLETION_FILE}"
}

docker_clean() {
	docker rm `docker ps --no-trunc -aq`
	docker images | grep "<none>" | awk '{ print "docker rmi " $3 }' | bash
	docker volume rm $(docker volume ls -qf dangling=true)
}

docker_clean_hard() {
	docker rmi -f $(docker images -q)
}
