#############
### build ###
#############

# base image
FROM node:16 as build

# install chrome for protractor tests
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
RUN apt-get update && apt-get install -yq google-chrome-stable

# set working directory
WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH
RUN npm install -g @angular/cli
# install and cache app dependencies
COPY package.json /app/package.json
RUN npm install --legacy-peer-deps
# RUN ng update @angular/cli @angular/core
# RUN npm audit fix --force

# add app
COPY . /app

# run tests
# RUN ng test --watch=false
# RUN ng e2e --port 4202

# generate build
#RUN ng build --prod --aot --vendor-chunk --common-chunk  --output-path=dist --buildOptimizer
RUN ng build --configuration production --aot --vendor-chunk --common-chunk  --output-path=dist --build-optimizer --output-hashing=all
############
### prod ###
############

# base image
FROM nginx:alpine

# copy artifact build from the 'build environment'

COPY nginx.conf /etc/nginx/nginx.conf

COPY backend-tls.crt /etc/nginx/ssl/backend-tls.crt
COPY backend-tls.key /etc/nginx/ssl/backend-tls.key
# COPY tachyhealthapp.net/. /etc/nginx/certs/fullchain.pem

COPY --from=build /app/dist /usr/share/nginx/html

# expose port 80
EXPOSE 80
EXPOSE 9443
# run nginx
CMD ["nginx", "-g", "daemon off;"]
