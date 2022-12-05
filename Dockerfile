FROM ruby:3.1.3

RUN apt-get update -qq && apt-get install -y build-essential

WORKDIR /opt/app

COPY Gemfile      Gemfile
COPY Gemfile.lock Gemfile.lock

RUN gem install bundler -N
RUN bundle config set without 'development test'
RUN bundle config set deployment 'true'a

RUN bundle install -j4

COPY bin bin
COPY config.ru config.ru
COPY db db
COPY Rakefile Rakefile
COPY lib lib
COPY app app
COPY --chown=nobody:nogroup config config
COPY REVISION      REVISION
RUN mkdir -p log tmp/pids
CMD ["sh", "-c", "bundle exec rake db:migrate && bundle exec puma"]
