FROM python:3.8.1-alpine3.11
ADD ./ ./app
RUN pip install -r requirements
CMD hypercorn whoami:app
