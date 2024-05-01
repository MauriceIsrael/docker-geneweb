#!/bin/bash

# Replace <package-url> with the URL of the package you want to download
# https://github.com/geneweb/geneweb/releases/latest
package_url=https://github.com/geneweb/geneweb/releases/download/v7.1-beta/geneweb-linux.zip

# Download the package using curl
curl -L $package_url -o /tmp/package.zip

# Extract the package to the /opt directory
DIR_PATH="/opt/geneweb"

if [ -d "$DIR_PATH" ]; then
  echo "Directory $DIR_PATH already exists."
else
  echo "Directory $DIR_PATH does not exist."
  mkdir /opt/geneweb
fi
unzip /tmp/package.zip -d /opt/geneweb/

# Remove the downloaded package file
rm /tmp/package.zip

