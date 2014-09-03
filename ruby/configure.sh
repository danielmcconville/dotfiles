if ! rbenv versions | grep 'jruby-1.7.9' 1>/dev/null
then
	rbenv install jruby-1.7.9
fi

if ! rbenv versions | grep '1.9.3-p484' 1>/dev/null
then
	rbenv install 1.9.3-p484
fi

if ! rbenv versions | grep '2.1.0' 1>/dev/null
then
	rbenv install 2.1.0
fi

rbenv global 1.9.3-p484

gem install lunchy
lunchy install /usr/local/opt/mongodb/homebrew.mxcl.mongodb.plist
lunchy install /usr/local/opt/redis/homebrew.mxcl.redis.plist

gem install bundler

heroku plugins:install git://github.com/ddollar/heroku-accounts.git

