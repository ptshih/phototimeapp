web: bundle exec unicorn -p $PORT
worker: bundle exec rake resque:work QUEUE=*
clock: bundle exec clockwork lib/clock.rb
