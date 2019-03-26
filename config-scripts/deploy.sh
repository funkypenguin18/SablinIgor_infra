#! /bin/bash

echo "Deploy app..."
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install

echo "Run app..."
puma -d
