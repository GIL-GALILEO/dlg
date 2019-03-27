FROM ruby:2.4.5
RUN apt-get update -qq && apt-get install -y nodejs
RUN mkdir /dlg
WORKDIR /dlg
COPY Gemfile /dlg/Gemfile
COPY Gemfile.lock /dlg/Gemfile.lock
RUN bundle install
ADD . /dlg

# Add a script to be executed every time the container starts.
#COPY entrypoint.sh /usr/bin/
#RUN chmod +x /usr/bin/entrypoint.sh
#RUN "curl 'http://localhost:6983/solr/meta-test/update?commit=true' --data-binary '@provision/data.json' -H 'Content-type:application/json'"
#ENTRYPOINT ["entrypoint.sh"]
ENTRYPOINT bundle exec rspec
#EXPOSE 3000

# Start the main process.
#CMD ["rails", "server", "-b", "0.0.0.0"]
