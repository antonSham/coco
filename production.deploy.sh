#!/usr/bin/env bash

./production.sh build

./production.sh up -d db

./production.sh run --rm api bash <<- END
  export SECRET_KEY_BASE=my_secret_key
  bundle check || bundle install --jobs=10 --retry=10
  bundle exec rake db:migrate 2>/dev/null || bundle exec rake db:setup
END

./production.sh up -d

# Pull data
./production.sh run --rm sidekiq bundle exec rails c <<- END
  PullWorker.perform_async
END
