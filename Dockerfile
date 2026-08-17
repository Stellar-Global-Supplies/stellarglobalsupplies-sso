FROM casbin/casdoor:latest

COPY app.conf /conf/app.conf
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]