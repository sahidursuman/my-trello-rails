source 'https://rubygems.org'
ruby '2.3.1'

# Primary Libraries
gem 'rails', '4.2.6'
gem 'pg'

# Preprocessors
gem 'haml-rails'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'

# Front-End Libraries
gem 'jquery-rails'
gem 'bootstrap-sass'
gem 'bootstrap_form', '~> 2.5'
gem 'bower-rails'
gem 'handlebars_assets'
gem 'autoprefixer-rails'

# Back-End Libraries
gem 'jbuilder', '~> 2.0'
gem 'bcrypt', '~> 3.1.7'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'figaro'

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails'
  gem 'fabrication'
  gem 'faker'
end

group :development do
  gem 'web-console', '~> 2.0'

  gem 'spring'
  gem "better_errors"
  gem "binding_of_caller"
end

group 'test' do
  gem 'database_cleaner', '1.4.1'
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'vcr'
end

group :production do
  gem 'rails_12factor'
end
