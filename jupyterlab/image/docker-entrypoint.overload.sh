#!/bin/bash


# Git clone/pull stuff
if [ "$GIT_REPO" != "" ]; then
  if [ ! -d /home/jovyan/work/.git/ ]; then
    echo "--> $(date '+%Y-%m-%d %H:%M:%S') - Git clone du dépot $GIT_REPO pour donner à manger data/ipynb/* à JupyterLab"
    rm -rf /home/jovyan/work/
    git config --global pull.rebase false
    git clone "$GIT_REPO" /home/jovyan/work/
  else
    echo "--> $(date '+%Y-%m-%d %H:%M:%S') - Git clone du dépot $GIT_REPO déjà réalisé dans /home/jovyan/work/"
  fi
else
  echo "--> $(date '+%Y-%m-%d %H:%M:%S') - Erreur: GIT_REPO doit être renseigné pour pouvoir travailler avec des fichiers ipynb collaborativement"
  exit 1
fi

# start the real entrypoint
# see https://github.com/jupyter/docker-stacks/blob/master/base-notebook/Dockerfile#L147
exec tini -g -- $@
