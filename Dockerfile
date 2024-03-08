ARG DOCS_IMAGE=sharinghub-docs:latest
ARG WEB_UI_IMAGE=sharinghub-ui:latest
ARG SERVER_IMAGE=sharinghub-server:latest

FROM ${DOCS_IMAGE} as docs

FROM ${WEB_UI_IMAGE} as web-ui

FROM ${SERVER_IMAGE}

ARG VERSION=latest

LABEL version=${VERSION}

ENV STATIC_FILES_PATH=/home/app/statics

COPY --from=web-ui /usr/share/nginx/html statics
COPY --from=docs /usr/share/nginx/html statics/docs
