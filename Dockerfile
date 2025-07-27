# syntax=docker/dockerfile:1
FROM ruby:3.4.5
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash
RUN curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq
RUN apt-get install -y nodejs cmake yarn
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install && bundle clean --force

COPY bin/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["bin/entrypoint.sh"]
EXPOSE 3000
EXPOSE 8983

# CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
