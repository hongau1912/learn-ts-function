FROM node:18-alpine as builder
WORKDIR /app
COPY ./package.json ./
RUN yarn config set network-timeout 60000 -g && yarn
COPY ./src ./src
COPY ./nest-cli.json ./nest-cli.json
COPY ./tsconfig.json ./tsconfig.json
COPY ./tsconfig.build.json ./tsconfig.build.json
RUN yarn build
FROM node:18-alpine as modules
WORKDIR /app
COPY ./package.json ./
RUN yarn config set network-timeout 60000 -g && yarn install --production
FROM node:18-alpine as runner
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}
WORKDIR /app
COPY ./package.json ./
COPY --from=modules /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
ENV PATH /app/node_modules/.bin:$PATH
RUN touch .env
RUN mkdir -p /tmp/.yarn-cache-1000
RUN mkdir -p /.cache/yarn
RUN mkdir -p /.yarn
RUN chown -R 1000:1000 /app
RUN chown -R 1000:1000 /tmp/.yarn-cache-1000
RUN chown -R 1000:1000 /.cache/yarn
RUN chown -R 1000:1000 /.yarn
USER 1000
CMD ["node", "dist/main"]