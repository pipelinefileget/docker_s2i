##--------------------------##
#FROM centos:latest
FROM centos:centos7
#FROM centcustom:latest
##--------------------------##

RUN yum install -y curl
RUN yum install -y git

LABEL io.openshift.s2i.scripts-url=image:///usr/libexec/s2i

ENV STI_SCRIPTS_PATH=/usr/libexec/s2i
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION v10.19.0
ENV NVM_NODEJS_ORG_MIRROR=http://nodejs.org/dist

RUN mkdir $NVM_DIR
RUN WORKDIR=$NVM_DIR

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash \
    && source $NVM_DIR/nvm.sh && nvm install $NODE_VERSION \
    && cd /root \
    && /usr/local/nvm/versions/node/v10.19.0/bin/npm \
    && /usr/local/nvm/versions/node/v10.19.0/bin/npm \
    && /usr/local/nvm/versions/node/v10.19.0/bin/npm init --yes \
    && /usr/local/nvm/versions/node/v10.19.0/bin/npm install express

RUN mkdir /root/app
WORKDIR /root/app
RUN git init

RUN git remote add origin https://github.com/pipelinefileget/app.git \
    && git clone https://github.com/pipelinefileget/app.git
RUN cp /root/app/pipelinefileget/app.js /root

WORKDIR /root

EXPOSE 3000

CMD /usr/local/nvm/versions/node/v10.19.0/bin/node app.js
