FROM ruby:2.3.6

ENV INSTALL_PATH /app

# Essential dependencies
RUN apt-get update -qq && apt-get install -y build-essential vim mysql-client git wget libfreetype6 libfontconfig bzip2

# PhantomJS
ENV PHANTOMJS_VERSION 2.1.1
RUN wget --no-check-certificate -q -O - https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 | tar xjC /opt
RUN ln -s /opt/phantomjs-$PHANTOMJS_VERSION-linux-x86_64/bin/phantomjs /usr/bin/phantomjs

# Setup working directory
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH

# For working with locally installed gems
#COPY vendor ./vendor

# Add github to known_hosts
RUN mkdir -p ~/.ssh
RUN ssh-keyscan github.com >> ~/.ssh/known_hosts

# Install gems in cachable way
COPY Gemfile Gemfile.lock ./
RUN bundle config --global github.https true
RUN gem install bundler && bundle install --jobs 20 --retry 5

# Copy source into container
COPY . .
