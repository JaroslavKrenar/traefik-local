FROM debian:11.6-slim AS builder

RUN apt-get update && apt-get install -y \
    libnss3-tools \
    curl

RUN curl -JLO "https://dl.filippo.io/mkcert/latest?for=linux/amd64"
RUN chmod +x mkcert-v*-linux-amd64
RUN cp mkcert-v*-linux-amd64 /usr/local/bin/mkcert

FROM traefik:v2.10.1
COPY --from=builder /usr/local/bin/mkcert /usr/local/bin/mkcert