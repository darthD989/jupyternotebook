FROM jupyter/base-notebook:latest
MAINTAINER LabInfrastructure

USER root

RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y software-properties-common && \
  apt-get install -y openssh-server && \
  apt-get install openssh-client -y && \
  apt-get install -y iputils-ping && \
  apt-get install -y vim && \
  apt-get install -y tmux && \
  apt-get install -y telnet && \
  apt-get install -y sudo && \
  apt-get install -y git

ADD ./jira_lib.tar.gz /home/jovyan/
ADD ./ctl_certs.tar.gz /usr/local/share/ca-certificates/

RUN update-ca-certificates && \
	adduser jovyan sudo && \
	git config --global user.email "neil.dirden@centurylink.com" && \
	git config --global user.name "Neil Dirden"

COPY ./work/ /home/jovyan/work/

USER jovyan
COPY ./requirements.txt /home/jovyan/
RUN pip install --trusted-host pypi.python.org -r requirements.txt

RUN mkdir -p ~/.ssh && \
  echo "Host *\n\tStrictHostKeyChecking no\n\n" > ~/.ssh/config 

RUN git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
COPY ./.vimrc /home/jovyan

ADD ./id_rsa /home/jovyan/.ssh/

#RUN cd work/lib/ && \
#	git clone git@NE1ITCPRHAS62.ne1.savvis.net:LABOPS_DEV/labtools-txlib.git
#USER root
