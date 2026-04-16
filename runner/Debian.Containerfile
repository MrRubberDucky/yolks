# based on https://github.com/pelican-eggs/yolks/blob/master/oses/debian/Dockerfile
# runner/debian
FROM    public.ecr.aws/docker/library/debian:trixie-slim
LABEL   org.opencontainers.image.source="https://github.com/mrrubberducky/yolks"
LABEL   org.opencontainers.image.licenses=MIT

ENV     DEBIAN_FRONTEND=noninteractive \
        USER=container \
        HOME=/home/container

RUN useradd -m -d /home/container -s /bin/bash container \
    && ln -s /home/container/ /nonexistent

## Update base packages
RUN apt update \
    && apt upgrade -y

## Install what's required dependencies
RUN apt install -y --no-install-recommends ca-certificates

## UT2004 dependencies
RUN dpkg --add-architecture i386 \
      && apt update \
      && apt install -y --no-install-recommends lib32gcc-s1 libsdl2-2.0-0:i386 libc6:i386

## libstdc++5_3.3.6-34 for x86
RUN if [ "$(uname -m)" = "x86_64" ]; then \
      curl -SL -o ./libstdc.deb https://web.archive.org/web/20260416130619/https://ftp.debian.org/debian/pool/main/g/gcc-3.3/libstdc++5_3.3.6-34_i386.deb && \
      dpkg -i libstdc.deb && \
      rm libstdc.deb; \
    fi

## Configure locale
RUN update-locale lang=en_US.UTF-8 \
      && dpkg-reconfigure --frontend noninteractive locales

WORKDIR    /home/container

STOPSIGNAL SIGINT

COPY        --chown=container:container ./runner/entrypoint.sh /entrypoint.sh
RUN         chmod +x /entrypoint.sh
ENTRYPOINT  ["/usr/bin/tini", "-g", "--"]
CMD         ["/entrypoint.sh"]
