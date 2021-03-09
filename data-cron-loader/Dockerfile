FROM alpine:3.13

RUN apk add git curl jq bash

RUN mkdir /shared_data && mkdir /temp_data

COPY tasks /etc/cron.d/tasks
COPY scripts /scripts
RUN chmod -R +x /scripts

RUN crontab /etc/cron.d/tasks

ENTRYPOINT ["crond", "-f"]