# Docker port of the ila Vagrant build environment (see bootstrap.sh).
#
# Ubuntu 18.04 is required: the build needs Python 2 bindings for
# fontforge/poppler, scons on py2, and the patched Inkscape 0.92 deb.
# Build for linux/amd64 (the Inkscape deb is amd64-only):
#
#   docker build --platform linux/amd64 -t ila-build build-environment
#
# Run from the repo root, mounting the repo at /base and persistent
# volumes for the build output and cache (paths hardcoded in SConstruct):
#
#   docker run --rm --platform linux/amd64 \
#     -v "$PWD":/base -v ila-build:/home/vagrant/build \
#     -v ila-cache:/home/vagrant/cache -w /base ila-build \
#     scons subpackages
#
FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    python-minimal \
    python3-minimal \
    python-pip \
    python3-pip \
    libcairo2-dev \
    pkg-config \
    trang \
    xsltproc \
    ruby-dev \
    scons \
    python-mako \
    coffeescript \
    npm \
    python-poppler \
    fontforge \
    python-fontforge \
    libxml2-utils \
    inkscape \
    git \
    curl \
    make \
    && rm -rf /var/lib/apt/lists/*

# texlive-full is enormous; install it in its own layer so failures
# elsewhere don't force a re-download.
RUN apt-get update && apt-get install -y texlive-full \
    && rm -rf /var/lib/apt/lists/*

COPY pycairo-1.15.4.tar.gz inkscape-patched_0.92.3-1_amd64.deb /tmp/

RUN pip2 install pdfrw && pip2 install /tmp/pycairo-1.15.4.tar.gz
# beautifulsoup4 pinned: newer releases use py3.7+ syntax
RUN pip3 install cssutils lxml "beautifulsoup4==4.9.3" mako pyyaml

# Patched Inkscape (overwrites the stock 0.92 installed above, which
# provided the dependencies).
RUN dpkg -i /tmp/inkscape-patched_0.92.3-1_amd64.deb

# Pin ffi/rb-inotify: their current releases require Ruby >= 3, but once
# compatible versions are installed, gem uses them to satisfy compass's deps.
RUN gem install ffi -v 1.12.2 && \
    gem install rb-inotify -v 0.9.10 && \
    gem install multi_json -v 1.15.0 && \
    gem install compass -v 1.0.3

# Ubuntu 18.04's npm 3.5.2 can no longer talk to the npm registry
# (EMISSINGARG); the official Node 8 tarball bundles npm 6, which can,
# while staying old enough for mathbox's gulp 3 build.  Installed to
# /usr/local so it shadows the apt node/npm.
RUN curl -fsSL https://nodejs.org/dist/v8.17.0/node-v8.17.0-linux-x64.tar.xz \
    | tar -xJ -C /usr/local --strip-components=1
ENV npm_config_unsafe_perm=true

# SConstruct hardcodes these paths (from the Vagrant VM layout).
RUN mkdir -p /home/vagrant/build /home/vagrant/cache

WORKDIR /base
