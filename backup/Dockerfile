FROM amazon/aws-cli:latest

RUN yum install -y mysql && yum clean all

COPY backup.sh /backup.sh
RUN chmod +x /backup.sh

ENTRYPOINT ["/backup.sh"]
