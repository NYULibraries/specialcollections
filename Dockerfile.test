FROM ruby:2.3.6

ENV INSTALL_PATH /app

# Essential dependencies
RUN apt-get update -qq && apt-get install -y \
      bzip2 \
      git \
      libfontconfig \
      libfreetype6 \
      vim \
      wget

# PhantomJS
ENV PHANTOMJS_VERSION 2.1.1

RUN wget --no-check-certificate -q -O - https://cnpmjs.org/mirrors/phantomjs/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 | tar xjC /opt
RUN ln -s /opt/phantomjs-$PHANTOMJS_VERSION-linux-x86_64/bin/phantomjs /usr/bin/phantomjs

RUN mkdir -p /bundle && chown 1000:2000 /bundle

# Add bundle entry point to handle bundle cache
COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

RUN groupadd -g 2000 docker -r && \
    useradd -u 1000 -r --no-log-init -m -d $INSTALL_PATH -g docker docker
USER docker

WORKDIR $INSTALL_PATH

RUN wget --no-check-certificate -q -O - https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh > /tmp/wait-for-it.sh
RUN chmod a+x /tmp/wait-for-it.sh

# Add github to known_hosts
RUN mkdir -p ~/.ssh
RUN ssh-keyscan github.com >> ~/.ssh/known_hosts

# Copy source into container
COPY --chown=docker:docker . .

ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"
RUN gem install bundler -v 1.16.3
