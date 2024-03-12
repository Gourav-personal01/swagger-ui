FROM nginx:1.25.4-alpine

RUN apk add "nodejs"

LABEL maintainer="char0n"

ENV API_KEY="**None**" \
    SWAGGER_JSON="/app/swagger.json" \
    PORT="80" \
    PORT_IPV6="" \
    BASE_URL="/" \
    SWAGGER_JSON_URL="" \
    CORS="true" \
    EMBEDDING="false"

COPY --chown=nginx:nginx --chmod=0666 ./docker/default.conf.template ./docker/cors.conf ./docker/embedding.conf /etc/nginx/templates/

COPY --chmod=0666 ./dist/* /usr/share/nginx/html/
COPY --chmod=0555 ./docker/docker-entrypoint.d/ /docker-entrypoint.d/
COPY --chmod=0666 ./docker/configurator /usr/share/nginx/configurator

# Simulates running NGINX as a non-root user; in the future, we want to use nginxinc/nginx-unprivileged.
# In the future, we will have separate unprivileged images tagged as v5.1.2-unprivileged.
RUN chmod 777 /usr/share/nginx/html/ /etc/nginx/conf.d/ /etc/nginx/conf.d/default.conf /var/cache/nginx/ /var/run/

# Expose either port 80 or 443, based on your preference
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
