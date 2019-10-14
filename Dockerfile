FROM ruby:2.5.5-alpine

ENV DOCKER true
ENV INSTALL_PATH /app

RUN addgroup -g 1000 -S docker && \
  adduser -u 1000 -S -G docker docker

WORKDIR $INSTALL_PATH
RUN chown docker:docker .

# bundle install
COPY --chown=docker:docker bin/ bin/
COPY --chown=docker:docker Gemfile Gemfile.lock ./
ARG RUN_PACKAGES="ca-certificates fontconfig mariadb-dev nodejs tzdata git"
ARG BUILD_PACKAGES="ruby-dev build-base linux-headers mysql-dev python"
RUN apk add --no-cache --update $RUN_PACKAGES $BUILD_PACKAGES \
  && gem install bundler -v '1.16.6' \
  && bundle config --local github.https true \
  && bundle install --without no_docker --jobs 20 --retry 5 \
  && rm -rf /root/.bundle && rm -rf /root/.gem \
  && rm -rf /usr/local/bundle/cache \
  && apk del $BUILD_PACKAGES \
  && chown -R docker:docker /usr/local/bundle

# precompile assets; use temporary secret token to silence error, real token set at runtime
USER docker
COPY --chown=docker:docker . .
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
RUN alias genrand='LC_ALL=C tr -dc "[:alnum:]" < /dev/urandom | head -c40' \
  && SECRET_TOKEN=genrand SECRET_KEY_BASE=genrand \
  RAILS_RELATIVE_URL_ROOT=/search RAILS_ENV=production bin/rails assets:precompile \
  && unalias genrand

USER docker
EXPOSE 9292

CMD [ "./scripts/start.sh", "development" ]
