# 1: Use ruby 2.4.1 as base:
FROM ruby:2.4.1-alpine

# 2: We'll set the application path as the working directory
WORKDIR /usr/src

# 3: We'll set the working dir as HOME and add the app's binaries path to $PATH:
ENV HOME=/usr/src PATH=/usr/src/bin:$PATH

# 4: Expose the app web port:
EXPOSE 3000

# 5: Set the default command:
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]

# --- Install development and runtime dependencies: ---

# 6: Install the development & runtime packages:
RUN set -ex && apk add --no-cache \
  build-base \
  ca-certificates \
  less \
  libcurl \
  nodejs \
  openssl \
  tzdata

# 7: Copy the project's Gemfile + lock:
ADD Gemfile* /usr/src/

# 8: Install the current project gems - they can be safely changed later during
# development via `bundle install` or `bundle update`:
RUN set -ex && bundle install --jobs=4 --retry=3
