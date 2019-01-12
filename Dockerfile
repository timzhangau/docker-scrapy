FROM python:3.6-slim
LABEL maintainer="Tim Zhang"

# Never prompts the user for choices on installation/configuration of packages
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

# Scrapy Project ENV
ARG SCRAPY_VERSION=1.5
ARG PYTHON_DEPS="botocore"
ARG APP_HOME=/app

# install build dependencies and python packages
RUN set -ex \
&& buildDeps=' \
freetds-dev \
libkrb5-dev \
libsasl2-dev \
libssl-dev \
libffi-dev \
libpq-dev \
git \
' \
&& apt-get update -yqq \
&& apt-get upgrade -yqq \
&& apt-get install -yqq --no-install-recommends \
$buildDeps \
freetds-bin \
build-essential \
default-libmysqlclient-dev \
apt-utils \
curl \
rsync \
netcat \
locales \
&& useradd -ms /bin/bash -d ${APP_HOME} spider \
&& pip install -U pip setuptools wheel \
&& pip install scrapy==${SCRAPY_VERSION} \
&& if [ -n "${PYTHON_DEPS}" ]; then pip install ${PYTHON_DEPS}; fi \
&& apt-get purge --auto-remove -yqq $buildDeps \
&& apt-get autoremove -yqq --purge \
&& apt-get clean \
&& rm -rf \
/var/lib/apt/lists/* \
/tmp/* \
/var/tmp/* \
/usr/share/man \
/usr/share/doc \
/usr/share/doc-base

COPY entrypoint.sh /entrypoint.sh

RUN chown -R spider: ${APP_HOME}

USER spider
WORKDIR ${APP_HOME}
ENTRYPOINT ["/entrypoint.sh"]
# set default arg for entrypoint
CMD ["scrapy","crawl"]
