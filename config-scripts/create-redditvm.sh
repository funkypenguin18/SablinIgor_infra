#! /bin/bash

echo "Create vm with reddit app..."
gcloud compute instances create reddit-app\
  --image-family reddit-full \
  --tags puma-server \
  --restart-on-failure
  