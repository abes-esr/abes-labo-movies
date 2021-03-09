FROM alpine:3.13

RUN apk add git curl jq bash

RUN mkdir /shared-data-to-load && mkdir /temp-shared-data-to-load

COPY tasks /etc/cron.d/tasks
COPY scripts /scripts
RUN chmod -R +x /scripts

RUN crontab /etc/cron.d/tasks

ENTRYPOINT ["crond", "-f"]