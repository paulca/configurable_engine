source 'https://rubygems.org'

gem 'pry'
gem 'rake'

platforms :mri do
  gem 'sqlite3'
  gem 'mysql2'
  gem 'pg'
end

platforms :jruby do
  gem 'activerecord-jdbcsqlite3-adapter'
  gem 'activerecord-jdbcmysql-adapter'
  gem 'activerecord-jdbcpostgresql-adapter'
  gem 'jruby-openssl'
end

group :test do
  gem 'capybara'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'rspec-rails'
  gem 'rspec-collection_matchers'
end

gem 'rails', '~>4.2.0'
