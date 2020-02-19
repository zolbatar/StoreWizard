#!/usr/bin/env sh

# Remove old
rm -rf store

# Setup rails
rails new store
cd store

# Setup gems
echo gem \'spree\' >> GemFile
#bundle install

# Build DB + spree
rails g spree:site
rake spree:install
rake db:create
rake db:migrate

# Copy template & Data
cp ../users.rb db/sample/users.rb
cp -r ../preload vendor/plugins
rake preload:install
rake preload:import

# Heroku
#git init
#heroku create
#git add -A
#git commit -am "Initial"
#git push heroku master

# Expanded logging
#heroku addons:upgrade logging:expanded

# Database create & migrate
#heroku rake db:create
#heroku rake db:migrate
#heroku rake db:seed
#heroku rake db:admin:create

# Load data
#heroku rake preload:import

# DNS
#heroku addons:add custom_domains:basic
#heroku addons:add zerigo_dns:basic
#heroku domains:add lovefromgifts.co.uk
#heroku domains:add www.lovefromgifts.co.uk
