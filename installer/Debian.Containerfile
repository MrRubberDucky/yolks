# installer/debian
FROM    public.ecr.aws/docker/library/debian:trixie-slim

LABEL   org.opencontainers.image.source="https://github.com/mrrubberducky/yolks"
LABEL   org.opencontainers.image.licenses=MIT

ENV     DEBIAN_FRONTEND=noninteractive

RUN apt update \
    && apt upgrade -y \
    && apt install -y --no-install-recommends \
        ca-certificates coreutils bash bzip2 \
        7zip unzip curl wget tar jq wget
