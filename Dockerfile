FROM ubuntu:focal

#RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# update the repository sources list
# and install dependencies
# RUN apt-get update \
#    && apt-get install -y curl \
#    && apt-get -y autoclean

# nvm environment variables
#ENV NVM_DIR /usr/local/nvm
#ENV NODE_VERSION 12.16.3

# install nvm
# https://github.com/creationix/nvm#install-script
#RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash
#RUN curl --silent -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# install node and npm
#RUN source $NVM_DIR/nvm.sh \
#    && nvm install $NODE_VERSION \
#    && nvm alias default $NODE_VERSION \
#    && nvm use default

# add node and npm to path so the commands are available
#ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
#ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN apt-get update \
    && apt-get install -y nodejs \
    npm
    
# confirm installation
RUN node -v
RUN npm -v



#MikTex
ARG DEBIAN_FRONTEND=noninteractive

RUN    apt-get update \
    && apt-get install -y --no-install-recommends \
           apt-transport-https \
           ca-certificates \
           dirmngr \
           ghostscript \
           gnupg \
           gosu \
           make \
           perl \
           fonts-liberation \
           fonts-dejavu 

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys D6BC243565B2087BC3F897C9277A7293F59E4889
RUN echo "deb http://miktex.org/download/ubuntu focal universe" | tee /etc/apt/sources.list.d/miktex.list

RUN    apt-get update -y \
    && apt-get install -y --no-install-recommends \
           miktex

RUN    miktexsetup finish \
    && initexmf --admin --set-config-value=[MPM]AutoInstall=1 \
    && mpm --admin --update-db \
    && mpm --admin \
           --install amsfonts \
           --install biber-linux-x86_64 \
    && initexmf --admin --update-fndb


# запуск сайта
# создание директории приложения
WORKDIR /usr/src/app

# установка зависимостей
# символ астериск ("*") используется для того чтобы по возможности 
# скопировать оба файла: package.json и package-lock.json
COPY package*.json ./

RUN npm install
# Если вы создаете сборку для продакшн
# RUN npm ci --only=production

# копируем исходный код
COPY . .

RUN mkdir /usr/src/app/dnload
RUN mkdir /usr/.miktex
ENV MIKTEX_USERCONFIG=/usr/.miktex/texmfs/config
ENV MIKTEX_USERDATA=/usr/.miktex/texmfs/data
ENV MIKTEX_USERINSTALL=/usr/.miktex/texmfs/install


EXPOSE 2000
CMD [ "node", "app.js" ]