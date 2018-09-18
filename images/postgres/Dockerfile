FROM postgres:10-alpine

COPY docker-entrypoint-initdb.d/* /docker-entrypoint-initdb.d/
RUN chmod -R +x /docker-entrypoint-initdb.d/