source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'active_hash'
gem 'blacklight', '~> 6.10'
gem 'blacklight-gallery', '~> 0.9.0'
gem 'blacklight-maps', '~> 0.5.0'
gem 'blacklight_advanced_search', '~> 6.3'
gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'leaflet-rails', '= 1.0.3'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.1.3'
gem 'rsolr', '>= 1.0'
gem 'sass-rails', '~> 5.0'
gem 'sqlite3'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'

group :development, :test do
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'rspec-rails', '~> 3.5'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
  gem 'xray-rails'
end