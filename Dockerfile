# Casdoor SSO - Production image for Render
FROM casbin/casdoor:latest

# Copy config template
COPY app.conf /conf/app.conf

# Copy entrypoint with executable permission set at copy time
# (base image is distroless so chmod command is unavailable)
COPY --chmod=755 entrypoint.sh /entrypoint.sh

EXPOSE 8000

ENTRYPOINT ["/entrypoint.sh"]