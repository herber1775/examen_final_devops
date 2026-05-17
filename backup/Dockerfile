FROM python:3.11-alpine

RUN apk add --no-cache mysql-client bash && \
    pip install --quiet awscli

COPY backup.sh /backup.sh
RUN chmod +x /backup.sh

ENTRYPOINT ["sh", "/backup.sh"]
