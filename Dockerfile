FROM casbin/casdoor:latest

USER root

COPY app.conf /conf/app.conf
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

USER 1000

ENTRYPOINT ["/entrypoint.sh"]