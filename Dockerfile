# Casdoor SSO - Production image for Zeabur
FROM casbin/casdoor:latest

# Copy config template
COPY app.conf /conf/app.conf

# Copy entrypoint that injects env vars into app.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8000

ENTRYPOINT ["/entrypoint.sh"]