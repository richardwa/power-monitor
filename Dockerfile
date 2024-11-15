FROM python:3.9-slim-bookworm

RUN apt-get update && \
    apt-get install -y mosquitto mosquitto-clients gnuplot


WORKDIR /app
COPY requirements.txt .
RUN pip install --root-user-action=ignore -r requirements.txt
COPY * ./

ENTRYPOINT [ "/app/start.sh" ]
