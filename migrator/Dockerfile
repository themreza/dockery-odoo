ARG  FROM_IMAGE=xoes/odoo-docker-base
FROM ${FROM_IMAGE}

# get marabunta as the odoo migration controller library of choice
RUN pip install marabunta

# You can configure marabunata either by environment variables
# or by config flags (which override env variables)
# Some arbitraty defaults
ENV MIGRATION_FILE .marabunta.yml
ENV DATABASE development
ENV DB_USER odoo
ENV DB_PASSWORD odoo
ENV DB_HOST db

ENTRYPOINT ["marabunta"]
CMD ["--help"]
