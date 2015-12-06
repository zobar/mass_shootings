FROM ruby:latest
RUN mkdir -p /usr/src/app/lib/mass_shootings
WORKDIR /usr/src/app/
COPY Gemfile mass_shootings.gemspec /usr/src/app/
COPY lib/mass_shootings/gemspec.rb lib/mass_shootings/version.rb \
     /usr/src/app/lib/mass_shootings/
RUN bundle install
COPY . /usr/src/app/
CMD bundle exec rake
