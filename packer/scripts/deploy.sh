#! /bin/bash

echo "Deploy app..."
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install

echo "Setup service..."
mv /tmp/puma.service /etc/systemd/system/puma.service
systemctl start puma
systemctl enable puma
