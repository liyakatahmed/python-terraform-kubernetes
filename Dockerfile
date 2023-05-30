FROM ubuntu:latest

RUN apt-get update && apt-get install -y python3

COPY app.py index.html /

WORKDIR /

EXPOSE 8000

CMD [ "python3", "app.py" ]