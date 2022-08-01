FROM cirrusci/flutter as builder
RUN sudo apt update && sudo apt install curl -y
COPY . /app
WORKDIR /app
RUN chmod -R 0777 scripts
RUN ./scripts/prepare-web.sh
RUN ./scripts/build-web.sh

FROM docker.io/nginx:alpine
RUN rm -rf /usr/share/nginx/html
COPY --from=builder /app/build/web /usr/share/nginx/html
