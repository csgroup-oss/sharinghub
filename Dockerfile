ARG DOCS_IMAGE=sharinghub-docs:latest
ARG WEB_UI_IMAGE=sharinghub-ui:latest
ARG SERVER_IMAGE=sharinghub-server:latest

FROM ${DOCS_IMAGE} AS docs

FROM ${WEB_UI_IMAGE} AS web-ui

FROM ${SERVER_IMAGE}

ARG VERSION=latest

LABEL version=${VERSION}

ENV STATIC_FILES_PATH=/var/www/sharinghub

USER root

RUN mkdir -p ${STATIC_FILES_PATH}

COPY --from=web-ui /usr/share/nginx/html ${STATIC_FILES_PATH}/ui
COPY --from=docs /usr/share/nginx/html ${STATIC_FILES_PATH}/docs

USER app
