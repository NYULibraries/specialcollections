FROM ruby:2.3.6-alpine

ENV INSTALL_PATH /app

RUN addgroup -g 1000 -S docker && \
  adduser -u 1000 -S -G docker docker

WORKDIR $INSTALL_PATH
RUN chown docker:docker .

RUN apk add --no-cache wget \
  && wget --no-check-certificate -q -O - https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh > /tmp/wait-for-it.sh \
  && chown docker:docker /tmp/wait-for-it.sh && chmod a+x /tmp/wait-for-it.sh \
  && apk del wget

# # Add github to known_hosts
# RUN mkdir -p ~/.ssh
# RUN ssh-keyscan github.com >> ~/.ssh/known_hosts

COPY --chown=docker:docker Gemfile Gemfile.lock ./
ARG RUN_PACKAGES="bash ca-certificates fontconfig git mariadb-dev nodejs tzdata python"
ARG BUILD_PACKAGES="ruby-dev build-base linux-headers mysql-dev"
RUN apk add --no-cache --update $RUN_PACKAGES $BUILD_PACKAGES \
  && bundle config --local github.https true \
  && gem install bundler && bundle install --without non_docker --jobs 20 --retry 5 \
  && rm -rf /root/.bundle && rm -rf /root/.gem \
  && rm -rf /usr/local/bundle/cache \
  && apk del $BUILD_PACKAGES \
  && chown -R docker:docker /usr/local/bundle

# RUN mkdir coverage && chown docker:docker coverage

USER docker

COPY --chown=docker:docker . .

RUN bundle install --without non_docker

EXPOSE 3000

CMD ./scripts/start.sh
