FROM python:3.10.12-slim AS sphinx-base

LABEL org.opencontainers.image.authors="Sphinx Team <https://www.sphinx-doc.org/>"
LABEL org.opencontainers.image.documentation="https://sphinx-doc.org/"
LABEL org.opencontainers.image.source="https://github.com/sphinx-doc/sphinx-docker-images"
LABEL org.opencontainers.image.version="7.3.7"
LABEL org.opencontainers.image.licenses="BSD-2-Clause"
LABEL org.opencontainers.image.description="Base container image for Sphinx"

WORKDIR /docs
RUN apt-get update \
 && apt-get install --no-install-recommends --yes \
      graphviz \
      imagemagick \
      make \
 && apt-get autoremove \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install --no-cache-dir --upgrade pip \
 && python3 -m pip install --no-cache-dir Sphinx==7.3.7 Pillow

CMD ["sphinx-build", "-M", "html", ".", "_build"]

FROM sphinx-base

WORKDIR /docs
COPY requirements.txt /docs
RUN pip3 install -U pip && pip3 install -r requirements.txt

RUN apt-get update \
    && apt-get install -y \
          git \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
