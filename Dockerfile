FROM python:3.13

RUN addgroup --gid 1024 ots
RUN adduser --home /app --disabled-password --gecos "" --force-badname --gid 1024 ots
RUN apt update && apt install ffmpeg -y

USER ots

WORKDIR /app/opentakserver

RUN chown -R ots:ots /app

RUN python -m venv /app/venv
ENV PATH="/app/venv/bin:$PATH"

# TODO: Install from PyPI
ENV OTS_GITHUB_USER=brian7704
RUN pip install git+https://github.com/${OTS_GITHUB_USER}/OpenTAKServer.git

RUN /app/venv/bin/flask --app /app/venv/lib/python3.13/site-packages/opentakserver/app.py ots create-ca
#RUN /app/venv/bin/flask --app /app/venv/lib/python3.13/site-packages/opentakserver/app.py db upgrade

ENV OTS_LISTENER_PORT=8081
EXPOSE $OTS_LISTENER_PORT

ENTRYPOINT ["opentakserver"]

# Flask will stop gracefully on SIGINT (Ctrl-C).
# Docker compose tries to stop processes using SIGTERM by default, then sends SIGKILL after a delay if the process doesn't stop.
STOPSIGNAL SIGINT

HEALTHCHECK --interval=1m CMD curl --fail http://localhost:$OTS_LISTENER_PORT/api/health || exit 1