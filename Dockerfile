FROM alpine:3.15 AS build
RUN apk --no-cache add \
    gomplate \
    make
WORKDIR /build
COPY . ./
RUN make

FROM alpine:3.15
RUN apk --no-cache add \
    nginx \
    yamllint
WORKDIR /app
COPY --from=build /build/build/web ./
COPY docker-nginx.conf /etc/nginx/nginx.conf
COPY .yamllintrc.yaml docker-entrypoint.sh ./
EXPOSE 80
ENTRYPOINT ["./docker-entrypoint.sh"]
