#!/usr/bin/env sh

# Remove old
rm -rf store
#rm preload/db/data/assets
#rm preload/db/data/assets.yml
#rm preload/db/data/products.yml
#rm preload/db/data/variants.yml

# Setup rails
rails new store
cd store

# Setup gems
echo gem \'spree\' >> GemFile

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

# Run
rails s
