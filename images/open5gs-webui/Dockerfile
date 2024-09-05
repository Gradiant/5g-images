FROM node:20.10.0-bullseye AS dev
LABEL maintainer="cgiraldo@gradiant.org" \
      organization="gradiant.org"

ARG version

ENV VERSION=$version \
    USER=open5gs \
    GROUP=open5gs

RUN curl -sSL https://github.com/open5gs/open5gs/archive/v${VERSION}.tar.gz | tar xvz -C /opt

RUN ln -s /opt/open5gs-${VERSION} /opt/open5gs


RUN cd /opt/open5gs-${VERSION}/webui && npm install  && npm run build


FROM node:20.10.0-bullseye-slim


ENV USER=open5gs \
    GROUP=open5gs \
    DB_URI=mongodb://mongo/open5gs

RUN groupadd -r $GROUP && \
    useradd --comment "open5gs" --shell /bin/bash -M -r -g $GROUP $USER

COPY --from=dev --chown=$GROUP:$USER /opt/open5gs/webui/ /opt/open5gs-webui

WORKDIR /opt/open5gs-webui
RUN npm run-script build
ENV NODE_ENV=production
ENV HOSTNAME="0.0.0.0"
RUN chown -R $GROUP:$USER /opt/open5gs-webui/
USER open5gs
ENTRYPOINT ["node", "server/index.js"]

