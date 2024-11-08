FROM --platform=linux/amd64 ubuntu:20.04

ARG MY_SERVICE_PORT=8080
RUN apt-get update && apt-get install -y \
    python3.8 \
    python \
    python3-pip

RUN pip install django
COPY . .
EXPOSE ${MY_SERVICE_PORT}
ENTRYPOINT ["bash","execute_commands.sh"]