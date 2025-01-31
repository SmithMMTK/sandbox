hostname && uptime
sudo apt update -y 

# Install the necessary packages for the proxy server
sudo apt-get install squid

# sudo vi /etc/squid/squid.conf

# Find "/http_access and change to "http_access allow all"
# Find "/http_access deny all" and comment it
# Tip: press "/" then type http_access, use "n" for next word

# sudo systemctl restart squid

# sudo squid -k debug