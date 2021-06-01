FROM jupyter/minimal-notebook:lab-3.0.15

RUN pip install sparqlkernel

# remarque: besoin de basculer en root puis de faire un fix-permissions
#           pour installer le kernel sparql dans jupyter
USER root
RUN jupyter sparqlkernel install \
    && fix-permissions "/home/${NB_USER}"
USER $NB_USER

