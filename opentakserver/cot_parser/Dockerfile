FROM python:3.13

RUN addgroup --gid 1024 ots
RUN adduser --home /app --disabled-password --gecos "" --force-badname --gid 1024 ots

WORKDIR /app/opentakserver

COPY . /app/

RUN chown -R ots:ots /app

RUN python -m venv /app/venv
ENV PATH="/app/venv/bin:$PATH"

ENV OTS_GITHUB_USER=brian7704
RUN pip install git+https://github.com/${OTS_GITHUB_USER}/OpenTAKServer.git@docker

USER ots

ENTRYPOINT ["/app/venv/bin/cot_parser"]

# Flask will stop gracefully on SIGINT (Ctrl-C).
# Docker compose tries to stop processes using SIGTERM by default, then sends SIGKILL after a delay if the process doesn't stop.
STOPSIGNAL SIGINT