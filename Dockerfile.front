FROM node:18-alpine3.16 AS development
WORKDIR /app

COPY package.json /app/package.json
COPY package-lock.json /app/package-lock.json

RUN npm ci
COPY . .

CMD ["npm", "run", "dev", "--", "--host"]

FROM development AS build
RUN npm run build-only

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
CMD ["nginx", "-g", "daemon off;"]
