### In Docker Image


RUN sed -i -e 's/https:\/\/dl-cdn\.alpinelinux\.org/https:\/\/myartifactoryurl.com\/alpine-remote/g' /etc/apk/repositories


###

RUN sh -c "echo 'deb https://myartifactoryurl.com/ubuntu-remote bionic main' >> /etc/apt/sources.list"
