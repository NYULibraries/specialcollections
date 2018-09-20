FROM ruby:2.3.6

ENV INSTALL_PATH /app

# Essential dependencies
RUN apt-get update -qq && apt-get install -y \
      wget

RUN groupadd -g 2000 docker -r && \
    useradd -u 1000 -r --no-log-init -m -d $INSTALL_PATH -g docker docker
USER docker

WORKDIR $INSTALL_PATH

RUN wget --no-check-certificate -q -O - https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh > /tmp/wait-for-it.sh
RUN chmod a+x /tmp/wait-for-it.sh

# Add github to known_hosts
RUN mkdir -p ~/.ssh
RUN ssh-keyscan github.com >> ~/.ssh/known_hosts

# bundle install
COPY --chown=docker:docker Gemfile Gemfile.lock ./
USER root
RUN bundle config --local github.https true \
  && gem install bundler && bundle install --jobs 20 --retry 5 \
  && chown -R docker:docker /usr/local/bundle
USER docker

# copy source
COPY --chown=docker:docker . .

RUN rm -rf bin/ && bundle install

CMD bundle exec rails server -b 0.0.0.0
