FROM texlive/texlive:latest

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Moscow

#install fonts
RUN    apt-get update \
    && apt-get install -y --no-install-recommends \
    fonts-liberation \
    fonts-dejavu \
    fonts-symbola \
    fonts-roboto 

#install node
#RUN apt-get update \
#    && apt-get install -y nodejs \
#    npm
#install node from script

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# update the repository sources list
# and install dependencies
# curl exists in texlive/texlive image
# RUN apt-get update \
#    && apt-get install -y curl \
#    && apt-get -y autoclean

# nvm environment variables
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 12.16.3

# install nvm
# https://github.com/creationix/nvm#install-script
RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash


# install node and npm
RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# add node and npm to path so the commands are available
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH


 
# confirm installation
RUN node -v
RUN npm -v



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

EXPOSE 2000
CMD [ "node", "app.js" ]