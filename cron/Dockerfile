FROM alpine:3.13

RUN mkdir $$DATA_OUTPUT_DIR
RUN apk add git curl jq bash

COPY tasks /etc/cron.d/tasks
COPY scripts /scripts
RUN chmod -R +x /scripts

RUN chmod 0744 /etc/cron.d/tasks
RUN crontab /etc/cron.d/tasks

CMD ["crond", "-f"]