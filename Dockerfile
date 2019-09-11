FROM mhart/alpine-node:10.16.3

WORKDIR /app

COPY package.json yarn.lock ./

RUN yarn

COPY . .

RUN yarn build

CMD ["npm", "start"]
