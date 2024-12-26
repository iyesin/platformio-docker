ARG HOMEDIR=/home/pio

FROM --platform=${BUILDPLATFORM:-linux/amd64} python:3-slim AS builder

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG HOMEDIR
ARG version

ENV PIO_VERSION=${version:-6.1.16}
ENV PIP_ROOT_USER_ACTION=ignore
ENV PLATFORMIO_CORE_DIR=/build/.platformio

RUN --mount=type=cache,target=/root/.pip \
    --mount=type=cache,target=/root/.cache \
    groupadd --force --system --gid 1000 pio \
    && useradd --home-dir ${HOMEDIR} --create-home \
        --uid 1000 --shell /bin/sh --comment "PlatformIO User" \
        --gid 1000 --groups tty,uucp,dialout,dip,plugdev pio \
    && mkdir -p /build \
    && chown -R pio:pio /build \
    && pip3 install platformio==$PIO_VERSION

LABEL Name="PlatformIO builder" \
      Release=https://github.com/platformio/platformio-core \
      Url=https://platformio.org \
      Help=https://docs.platformio.org/en/stable/ \
      org.opencontainers.image.source=https://github.com/iyesin/platformio-docker

WORKDIR /build

USER 1000

ENTRYPOINT [ "/usr/local/bin/pio", "run", "--project-dir", "/build" ]
