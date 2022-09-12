# Gitlab Runner for WSL
This WSL distro is perfect for Gitlab CI homelab setup, if you need to run multiple Gitlab Runner instances on Windows machines.  

## What you'll get
* Alpine based image with Docker & Docker Compose.
* Non-root user supplied through `build args`.
* Non-root user is a member of **admin** and **docker** groups, as well as **sudoers**.
* While running this image with WSL, non-root user is used by default.
* Docker daemon starts automatically on non-root user login.
* docker-compose file, in home folder, ready to start Gitlab Runner. 

## Prerequisites
To build this image you'll need Docker, of course. No specific requirements regarding version as far as I know. Unless you want to use **BuildKit** for building, then it's 18.09 or higher.  
To run the image WSL2 is required. Type `wsl --status` and check "Default Version".

## Build WSL distro
### Using Docker Build
> source: https://medium.com/nerd-for-tech/create-your-own-wsl-distro-using-docker-226e8c9dbffe
```
docker build --build-arg USER=myuser --build-arg PASS=PassW0rd --tag gitlab-runner-wsl .
docker run --name gitlab-runner-wsl gitlab-runner-wsl
docker export --output gitlab-runner-wsl.tar.gz gitlab-runner-wsl
```
### Using BuildKit
```
DOCKER_BUILDKIT=1 docker build --build-arg USER=myuser --build-arg PASS=PassW0rd --output type=tar,dest=gitlab-runner-wsl.tar.gz .
```

## Run WSL distro
```
wsl --import gitlab-runner-wsl .\gitlab-runner-wsl .\gitlab-runner-wsl.tar.gz
wsl --distribution gitlab-runner-wsl
```

## Register Gitlab Runner
1. From home folder, where **docker-compose.yml** is located, start container:
   ```
   docker-compose up -d
   ```
2. Register runner:
   ```
   docker exec -it gitlab-runner-1 gitlab-runner register --executor "docker" --env "GIT_SSL_NO_VERIFY=true"
   ```
3. There's no need to restart container. It should pick up config changes automatically.