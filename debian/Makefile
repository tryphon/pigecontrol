PATH := ${HOME}/.gem/ruby/1.8/bin:${HOME}/.bundle/ruby/1.8/bin:${PATH}

build:
	gem install --no-rdoc --no-ri --user-install bundler
	MAKEFLAGS="" bundle install --deployment --without=test development cucumber

	cp config/database.yml.sample config/database.yml

	bundle exec rake db:create db:migrate RAILS_ENV=production

	rm -rf vendor/bundle/ruby/1.8/bin vendor/bundle/ruby/1.8/cache vendor/bundle/ruby/1.8/doc
	rm -f config/database.yml

install:
	cp -a app bin public vendor config lib db script ${DESTDIR}usr/share/pige
	cp -a Gemfile Gemfile.lock .bundle ${DESTDIR}usr/share/pige
	rm -f ${DESTDIR}usr/share/pige/config/environments/production.rb
	cp debian/database.yml debian/production.rb debian/apache2.conf ${DESTDIR}etc/pige/

clean:
	rm -rf vendor/bundle db/production.sqlite3

