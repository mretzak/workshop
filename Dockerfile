# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.3.1
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim

# Rails app lives here
WORKDIR /rails

# Set development environment for workshop
ENV RAILS_ENV="development" \
    BUNDLE_PATH="/usr/local/bundle"

# Install packages needed for development and PostgreSQL
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    git \
    libpq-dev \
    libvips \
    pkg-config \
    curl \
    postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy application code
COPY . .

# Make sure entrypoint is executable
RUN chmod +x bin/docker-entrypoint

# Run and own only the runtime files as a non-root user for security
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails /rails
USER rails:rails

# Entrypoint prepares the database and starts the server
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default
EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
