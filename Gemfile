# frozen_string_literal: true

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
gem 'blacklight_range_limit', '~> 6.3'
gem 'bootstrap-sass', '>= 3.4.1'
gem 'chosen-rails', '~> 1.5.2'
gem 'coffee-rails', '~> 4.2'
gem 'exception_notification'
gem 'font-awesome-sass'
gem 'httparty', '~> 0.15.6'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'leaflet-rails', '= 1.0.3'
gem 'pg', '~> 0.21.0'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.2'
gem 'rsolr', '>= 1.0'
gem 'sass-rails', '~> 5.0'
gem 'sitemap_generator'
gem 'slack-notifier'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'

group :development, :test do
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'poltergeist'
  gem 'rspec-rails', '~> 3.5'
  gem 'webmock'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
  gem 'xray-rails'
end