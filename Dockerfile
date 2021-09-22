ARG UPSTREAM_VERSION=1.42.1

FROM alpine:latest as build
ARG UPSTREAM_VERSION
ADD https://github.com/sass/dart-sass/releases/download/${UPSTREAM_VERSION}/dart-sass-${UPSTREAM_VERSION}-linux-x64.tar.gz /opt/
RUN tar -C /opt/ -xzvf /opt/dart-sass-${UPSTREAM_VERSION}-linux-x64.tar.gz

FROM alpine:latest as final
ARG COMMIT
ARG DATE
ARG URL
ARG VERSION

LABEL maintainer="istvan@hegistvan.com" \
    org.opencontainers.image.created=$DATE \
    org.opencontainers.image.authors="Hegi; Michal Klempa" \
    org.opencontainers.image.url="https://hub.docker.com/r/hegistvan/dart-sass" \
    org.opencontainers.image.source=$URL \
    org.opencontainers.image.version="$VERSION" \
    org.opencontainers.image.revision=$COMMIT \
    org.opencontainers.image.vendor="Hegi" \
    org.opencontainers.image.licenses="LGPL-2.1" \
    org.opencontainers.image.title="hegistvan/dart-sass" \
    org.opencontainers.image.description="sass/dart-sass docker image for web development purposes. Runs sass --watch on provided volumes."
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--", "/opt/dart-sass/sass"]

COPY --from=build /opt/dart-sass /opt/dart-sass

CMD [ "--watch", "/sass:/css" ]
