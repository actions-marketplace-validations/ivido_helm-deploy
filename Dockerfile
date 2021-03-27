FROM alpine:3.13

ENV BASE_URL="https://get.helm.sh"

ENV HELM_2_FILE="helm-v2.17.0-linux-amd64.tar.gz"
ENV HELM_3_FILE="helm-v3.5.3-linux-amd64.tar.gz"

RUN apk add --no-cache ca-certificates \
    --repository http://dl-3.alpinelinux.org/alpine/edge/community/ \
    jq curl bash nodejs yarn && \
    \
    curl -L ${BASE_URL}/${HELM_2_FILE} | tar xvz && \
    mv linux-amd64/helm /usr/bin/helm && \
    chmod +x /usr/bin/helm && \
    rm -rf linux-amd64 && \
    \
    curl -L ${BASE_URL}/${HELM_3_FILE} | tar xvz && \
    mv linux-amd64/helm /usr/bin/helm3 && \
    chmod +x /usr/bin/helm3 && \
    rm -rf linux-amd64 && \
    helm init --client-only

COPY . /usr/src

RUN ["yarn", "install"]

ENTRYPOINT ["node", "--experimental-modules", "/usr/src/index.js"]