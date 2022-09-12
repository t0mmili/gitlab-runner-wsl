# The base image
FROM alpine:latest

# Non-root user
ARG USER
ARG PASS

# Install applications
RUN apk update && \
        apk upgrade --available && \
        apk add --no-cache \
        sudo \
	curl \
	ca-certificates \
        docker \
        docker-compose

# Setup non-root user 
COPY ./conf/profile /home/${USER}/.profile
RUN /bin/ash -c 'adduser -h /home/${USER} -s /bin/ash -g ${USER} ${USER}; echo "${USER}:${PASS}" | chpasswd; \
                 addgroup ${USER} wheel; \
                 addgroup ${USER} docker; \
                 chown ${USER}:${USER} /home/${USER}/.profile; \
                 echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers'

# Setup Gitlab Runner
COPY ./gitlab-runner/docker-compose.yml /home/${USER}/docker-compose.yml
RUN /bin/ash -c 'chown ${USER}:${USER} /home/${USER}/docker-compose.yml'

# Add wsl config file
COPY ./conf/wsl.conf /etc/wsl.conf
RUN /bin/ash -c 'echo "default = ${USER}" >> /etc/wsl.conf'

