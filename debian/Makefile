PATH := ${HOME}/.gem/ruby/1.8/bin:${HOME}/.bundle/ruby/1.8/bin:${PATH}

build:
	gem install --no-rdoc --no-ri --user-install bundler
	bundle install --deployment --without=test development cucumber
	ln -s bundle/ruby/1.8/gems vendor/gems

	cp config/database.yml.sample config/database.yml

	bundle exec rake rails:freeze:gems 
	bundle exec rake db:create db:migrate RAILS_ENV=production

	rm -rf vendor/bundle/ruby/1.8/bin vendor/bundle/ruby/1.8/cache vendor/bundle/ruby/1.8/doc vendor/bundle/ruby/1.8/specifications
	rm -rf vendor/gems/actionmailer-* vendor/gems/actionpack-* vendor/gems/activerecord-* vendor/gems/activeresource-* vendor/gems/activesupport-* vendor/gems/rails-*
	rm -f config/database.yml

install:
	cp -a app bin public vendor config lib db ${DESTDIR}usr/share/pige
	rm -f ${DESTDIR}usr/share/pige/config/environments/production.rb
	cp debian/database.yml debian/production.rb debian/apache2.conf ${DESTDIR}etc/pige/
	cp debian/syslog_logger.rb ${DESTDIR}usr/share/pige/lib

clean:
	rm -rf vendor/rails vendor/bundle vendor/gems db/production.sqlite3

