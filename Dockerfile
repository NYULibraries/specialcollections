FROM ruby:2.3.6

ENV INSTALL_PATH /app
ENV BUNDLE_PATH /usr/local/bundle

# Essential dependencies
RUN apt-get update -qq && apt-get install -y \
      wget

RUN groupadd -g 2000 docker -r && \
    useradd -u 1000 -r --no-log-init -m -d $INSTALL_PATH -g docker docker
USER docker

WORKDIR $INSTALL_PATH

RUN wget --no-check-certificate -q -O - https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh > /tmp/wait-for-it.sh
RUN chmod a+x /tmp/wait-for-it.sh

# For working with locally installed gems
#COPY vendor ./vendor

# Add github to known_hosts
RUN mkdir -p ~/.ssh
RUN ssh-keyscan github.com >> ~/.ssh/known_hosts

# Install gems in cachable way
COPY --chown=docker:docker Gemfile Gemfile.lock ./
RUN bundle config --global github.https true
RUN gem install bundler && bundle install --jobs 20 --retry 5

COPY --chown=docker:docker . .
