#
# Cette image docker surcharge ontotext/graphdb:9.6.0-free de façon à pouvoir disposer de la fonction loadrdf
# qui est ensuite utilisée pour charger toutes les nuits le dump turtle dans GraphDB
#
# A noter que cette image ontotext/graphdb:9.6.0-free n'est pas disponible sur dockerhub,
# elle est construite juste avant (cf docker-compose.yml section "build")
#
FROM ontotext/graphdb:9.6.0-free

RUN apk add git bash docker-cli

COPY tasks /etc/cron.d/tasks
COPY scripts /scripts
RUN chmod -R +x /scripts

RUN crontab /etc/cron.d/tasks

CMD []
ENTRYPOINT ["crond", "-f"]
