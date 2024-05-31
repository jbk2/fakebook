# Dockerfile
# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.3.0
FROM ruby:$RUBY_VERSION-slim as base

WORKDIR /rails

ENV RAILS_ENV="development" \ 
    BUNDLE_WITHOUT=""

RUN gem update --system --no-document && \
    gem install -N bundler

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential libpq-dev libvips 

COPY --link Gemfile Gemfile.lock ./

RUN bundle install

COPY --link . .

RUN bundle exec bootsnap precompile app/ lib/

COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R 1000:1000 db log storage tmp
USER 1000:1000

ENTRYPOINT ["/rails/bin/docker-dev-entrypoint"]

EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
