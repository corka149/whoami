FROM python:3.8.1-alpine3.11
RUN apk update && \
    apk --no-cache --update add gcc musl-dev

ADD ./ /app
WORKDIR /app
RUN pip install -r requirements.txt

CMD hypercorn whoami:app -b 0.0.0.0:8000
