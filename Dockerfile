FROM alpine:3.15.0

RUN apk add --no-cache openssl

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
