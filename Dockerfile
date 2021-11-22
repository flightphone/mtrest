FROM texlive/texlive:latest


ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Moscow

RUN apt-get update \
    && apt-get install -y nodejs \
    npm


 
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