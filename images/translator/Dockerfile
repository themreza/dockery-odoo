ARG  FROM_IMAGE
FROM ${FROM_IMAGE}

USER root

# get weblate API client
# # DOC: https://docs.weblate.org/en/latest/wlc.html
RUN pip install wlc
# get transifex API client
# # DOC: http://docs.transifex.com/client
RUN pip install transifex-client

# Install Hub API client
# # DOC: http://pygithub.readthedocs.io/en/latest/introduction.html
RUN pip install pygithub
# Install Lab API client
# # DOC: http://python-gitlab.readthedocs.io/en/stable/
RUN pip install python-gitlab

# Some git tools for standard diffing
RUN apt-get update && apt-get install -y --no-install-recommends git-core


COPY lib/* /usr/local/lib/python2.7/dist-packages/odoo-translator-libs/
ENV PATH=$PATH:/usr/local/lib/python2.7/dist-packages/odoo-translator-libs

USER odoo

ENTRYPOINT []
CMD []
