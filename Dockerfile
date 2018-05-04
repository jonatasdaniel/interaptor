FROM ruby:2.5

RUN apt-get update && apt-get install -y git

RUN touch ~/.gemrc && \
  echo "gem: --no-ri --no-rdoc" >> ~/.gemrc && \
  gem install rubygems-update && \
  update_rubygems && \
  gem install bundler && \
  mkdir -p /gem/

WORKDIR /interaptor/
ADD . /interaptor/
RUN bundle install

VOLUME .:/interaptor/


ENTRYPOINT ["bundle", "exec"]
CMD ["rspec", "spec"]
