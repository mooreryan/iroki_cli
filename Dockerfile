FROM ruby:2.3

MAINTAINER Ryan Moore <moorer@udel.edu>

RUN gem install iroki

ENTRYPOINT ["iroki"]

CMD ["--help"]
