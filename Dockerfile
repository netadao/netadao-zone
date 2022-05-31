FROM alpine AS site-builder

#.Install Certificates to establish SSL/TLS communication
RUN apk update && \
    apk --no-cache add ca-certificates

RUN apk add git tar 

#.Install hugo
RUN wget -O hugo.tar.gz https://github.com/gohugoio/hugo/releases/download/v0.100.0/hugo_0.100.0_Linux-64bit.tar.gz && \
    tar -zxvf hugo.tar.gz && mv hugo /usr/local/bin/

#.Copy source website and build static files
COPY . /hugo

RUN cd /hugo && hugo

#.Package site in nginx 
FROM nginx:stable-alpine

#.Copy static files
COPY --from=site-builder /hugo/public/. /usr/share/nginx/html