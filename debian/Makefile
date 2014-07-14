PATH := ${HOME}/.gem/ruby/1.9.1/bin:${HOME}/.bundle/ruby/1.9.1/bin:${PATH}

build:
	LANG="en_US.UTF-8" LC_ALL="en_US.UTF-8" gem1.9.1 install --no-rdoc --no-ri --user-install bundler
	MAKEFLAGS="" bundle install --deployment --without=test development

	cp config/database.yml.sample config/database.yml

	bundle exec rake db:create db:migrate assets:precompile RAILS_ENV=production

	rm vendor/bundle/ruby/*/cache/*.gem
	rm -f config/database.yml

install:
	cp -a app bin script public vendor config lib db ${DESTDIR}usr/share/pigecontrol
	cp -a Rakefile config.ru Gemfile Gemfile.lock .bundle ${DESTDIR}usr/share/pigecontrol
	rm -f ${DESTDIR}usr/share/pigecontrol/config/environments/production.rb
	cp debian/database.yml debian/production.rb debian/apache2.conf ${DESTDIR}etc/pigecontrol/

clean:
	rm -rf vendor/bundle db/production.sqlite3 config/database.yml
