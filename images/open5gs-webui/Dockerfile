FROM node:16.14 as dev
LABEL maintainer="cgiraldo@gradiant.org" \
      organization="gradiant.org"

ARG version=2.0.18

ENV VERSION=$version \
    USER=open5gs \
    GROUP=open5gs

RUN curl -sSL https://github.com/open5gs/open5gs/archive/v${VERSION}.tar.gz | tar xvz -C /opt

RUN ln -s /opt/open5gs-${VERSION} /opt/open5gs

RUN cd /opt/open5gs-${VERSION}/webui && npm install  && npm run build


FROM node:16.14-slim


ENV VERSION=$version \
    USER=open5gs \
    GROUP=open5gs \
    DB_URI=mongodb://mongo/open5gs

RUN groupadd -r $GROUP && \
    useradd --comment "open5gs" --shell /bin/bash -M -r -g $GROUP $USER
USER open5gs
COPY --from=dev --chown=$GROUP:$USER /opt/open5gs/webui/ /opt/open5gs-webui

WORKDIR /opt/open5gs-webui
RUN npm run-script build
ENV NODE_ENV=production
ENV HOSTNAME="0.0.0.0"
ENTRYPOINT ["node", "server/index.js"]

