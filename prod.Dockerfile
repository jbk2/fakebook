# Production Dockerfile used to build for Fakebook Ruby on Rails app container & sidekiq container
# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.3.0
FROM ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

ENV BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    RAILS_LOG_TO_STDOUT="1" \
    RAILS_SERVE_STATIC_FILES="true" \
    RAILS_ENV="production" \
    BUNDLE_WITHOUT="development:test"

RUN gem update --system --no-document && \
    gem install -N bundler

# --------------------------------------------

FROM base AS build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential libpq-dev libvips 

COPY --link Gemfile Gemfile.lock ./

RUN bundle install && \
    bundle exec bootsnap precompile --gemfile && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# Will include locally built assets
COPY --link . .

RUN bundle exec bootsnap precompile app/ lib/

# Not running `assets:precompile` here as assets are compiled locally
# (therefore no need for Node & Yarn here).
# RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# --------------------------------------------

FROM base

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl imagemagick libvips postgresql-client nano && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R 1000:1000 db log storage tmp
USER 1000:1000

ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
