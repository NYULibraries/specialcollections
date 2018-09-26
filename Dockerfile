FROM ruby:2.3.7-alpine

ENV INSTALL_PATH /app

RUN addgroup -g 1000 -S docker && \
  adduser -u 1000 -S -G docker docker

WORKDIR $INSTALL_PATH
RUN chown docker:docker .

RUN apk add --no-cache wget \
  && wget --no-check-certificate -q -O - https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh > /tmp/wait-for-it.sh \
  && chown docker:docker /tmp/wait-for-it.sh && chmod a+x /tmp/wait-for-it.sh \
  && apk del wget

# bundle install
COPY --chown=docker:docker Gemfile Gemfile.lock ./
ARG RUN_PACKAGES="bash ca-certificates fontconfig mariadb-dev nodejs tzdata"
ARG BUILD_PACKAGES="ruby-dev build-base linux-headers mysql-dev python git"
RUN apk add --no-cache --update $RUN_PACKAGES $BUILD_PACKAGES \
  && gem install bundler -v '1.16.5' \
  && bundle config --local github.https true \
  && bundle install --without non_docker --jobs 20 --retry 5 --binstubs \
  && rm -rf /root/.bundle && rm -rf /root/.gem \
  && rm -rf /usr/local/bundle/cache \
  && apk del $BUILD_PACKAGES \
  && chown -R docker:docker /usr/local/bundle

# precompile assets
USER docker
COPY --chown=docker:docker . .
RUN bundle exec rake assets:precompile

# run microscanner
USER root
ARG AQUA_MICROSCANNER_TOKEN
RUN wget -O /microscanner https://get.aquasec.com/microscanner && \
  chmod +x /microscanner && \
  /microscanner ${AQUA_MICROSCANNER_TOKEN} && \
  rm -rf /microscanner

USER docker
EXPOSE 9292

CMD ./scripts/start.sh development
