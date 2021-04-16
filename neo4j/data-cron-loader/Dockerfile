FROM neo4j:4.2.3

RUN apt update && apt install -y git curl jq cron

RUN mkdir /shared-data-to-load && mkdir /temp-shared-data-to-load

COPY tasks /etc/cron.d/tasks
COPY scripts /scripts
RUN chmod -R +x /scripts

RUN crontab /etc/cron.d/tasks

ENTRYPOINT ["cron", "-f"]