FROM alpine:3.15.0-rc.4 AS build
RUN apk --no-cache add \
    gomplate \
    make
RUN apk --no-cache \
    --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ add \
    pandoc
WORKDIR /build
COPY . .
RUN make

FROM alpine:3.14
RUN apk --no-cache add \
    nginx \
    yamllint
WORKDIR /app
COPY --from=build /build/build/web .
COPY docker-nginx.conf /etc/nginx/nginx.conf
COPY .yamllintrc.yaml .
COPY docker-entrypoint.sh .
EXPOSE 80
ENTRYPOINT ["./docker-entrypoint.sh"]
