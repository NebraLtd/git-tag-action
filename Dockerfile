FROM alpine
LABEL "repository"="https://github.com/NebraLtd/git-tag-action"
LABEL "homepage"="https://github.com/NebraLtd/git-tag-action"
LABEL "maintainer"="NebraLtd"

COPY entrypoint.sh /entrypoint.sh

RUN apk update && apk add bash git curl jq

ENTRYPOINT ["/entrypoint.sh"]
