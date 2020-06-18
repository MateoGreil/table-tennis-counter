FROM ruby:latest

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
	apt-get install -y nodejs
RUN curl -o- -L https://yarnpkg.com/install.sh | bash

COPY Gemfile Gemfile.lock /app/

WORKDIR /app

RUN bundle install

VOLUME /usr/local/bundle
