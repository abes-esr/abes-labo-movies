FROM jupyter/minimal-notebook:lab-3.0.15

# https://github.com/paulovn/sparql-kernel
# https://github.com/jupyterlab/jupyterlab-git
RUN pip install sparqlkernel jupyterlab-git

# remarque: besoin de basculer en root puis de faire un fix-permissions
#           pour installer le kernel sparql dans jupyter
USER root
RUN jupyter sparqlkernel install \
    && fix-permissions "/home/${NB_USER}"
COPY ./docker-entrypoint.overload.sh /
RUN fix-permissions "/docker-entrypoint.overload.sh"
USER $NB_USER

ENTRYPOINT ["/docker-entrypoint.overload.sh"]
# see https://github.com/jupyter/docker-stacks/blob/master/base-notebook/Dockerfile#L148
CMD ["start-notebook.sh"]

