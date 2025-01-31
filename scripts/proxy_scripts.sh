hostname && uptime
sudo apt update -y 

# Install the necessary packages for the proxy server
sudo apt-get install squid -y


# Replace string "http_access deny all" with "http_access allow all" in the squid configuration file
# Restart the squid service
# Enable debug mode for squid

sudo sed -i 's/http_access deny all/http_access allow all/' /etc/squid/squid.conf
sudo systemctl restart squid
sudo squid -k debug
