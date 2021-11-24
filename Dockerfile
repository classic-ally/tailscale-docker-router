FROM tailscale/tailscale:latest

RUN apk add --no-cache bash; exit 0

WORKDIR /
RUN wget https://raw.githubusercontent.com/cjbentley/tailscale-docker-router/main/main.sh
RUN wget https://raw.githubusercontent.com/cjbentley/tailscale-docker-router/main/runner.sh
RUN chmod +x main.sh
RUN chmod +x runner.sh

CMD ["./runner.sh"]