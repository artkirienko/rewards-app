# syntax=docker/dockerfile:1

# Development-focused Dockerfile for Rails 8 API with MySQL
ARG RUBY_VERSION=3.4.2
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Set working directory
WORKDIR /rails

# Install base packages needed for development, including libyaml-dev
RUN apt-get update -qq && \
  apt-get install --no-install-recommends -y \
  curl \
  default-mysql-client \
  libjemalloc2 \
  build-essential \
  default-libmysqlclient-dev \
  git \
  libyaml-dev \
  && rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set development environment
ENV RAILS_ENV="development" \
  BUNDLE_PATH="/usr/local/bundle" \
  BUNDLE_WITHOUT="production"

# Copy dependency files
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the rest of the application
COPY . .

# Make bin/setup executable
RUN chmod +x /rails/bin/setup

# Expose port for development
EXPOSE 3000

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Default command (can be overridden in docker-compose)
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
