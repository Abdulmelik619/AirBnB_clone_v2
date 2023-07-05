#!/usr/bin/env bash

# Install Nginx if it is not already installed
if ! dpkg -s nginx > /dev/null 2>&1; then
    sudo apt-get -y update
    sudo apt-get -y install nginx
fi

# Create the necessary directories
sudo mkdir -p /data/web_static/releases/test /data/web_static/shared

# Create a fake HTML file for testing
echo "<html><head></head><body>My Name is Abdulmelik Ambaw</body></html>" | sudo tee /data/web_static/releases/test/index.html

# Create a symbolic link to the /data/web_static/releases/test/ folder
sudo ln -sf /data/web_static/releases/test/ /data/web_static/current

# Set ownership of /data/ to the ubuntu user and group
sudo chown -R ubuntu:ubuntu /data/

# Update the nginx configuration to serve the content of /data/web_static/current/ to hbnb_static
sudo sed -i '/listen 80 default_server;/a location /hbnb_static/ {\n\talias /data/web_static/current/;\n}\n' /etc/nginx/sites-available/default

# Restart Nginx to apply the changes
sudo service nginx restart