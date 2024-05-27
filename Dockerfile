# Dockerfile
# syntax = docker/dockerfile:1

# 1. Define the Ruby version
ARG RUBY_VERSION=3.3.0
FROM ruby:$RUBY_VERSION-slim as base

# 2. Set the working directory
WORKDIR /rails

# 3. Set environment variables
ENV BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle"
    # BUNDLE_WITHOUT="development:test"
    # RAILS_ENV="production"

# 4. Update gems and bundler
RUN gem update --system --no-document && \
    gem install -N bundler

# 5. Build stage to reduce size of final image
FROM base as build

# 6. Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential libpq-dev libvips nodejs npm yarn

# 7. Install application gems
COPY --link Gemfile Gemfile.lock ./
RUN bundle install && \
    bundle exec bootsnap precompile --gemfile && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# 8. Copy application code
COPY --link . .

# 9. Install TailwindCLI
RUN npm install -g tailwindcss

# 10. Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# 11. Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# 12. Final stage for app image
FROM base

# 13. Install packages needed for deployment
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl imagemagick libvips postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# 14. Copy built artifacts: gems, application
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# 16. Run and own only the runtime files as a non-root user for security
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R 1000:1000 db log storage tmp
USER 1000:1000

# 17. Entrypoint prepares the database
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# 18. Start the server by default
EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
