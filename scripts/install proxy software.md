###############################################################################################
# Setup Squid Proxy Server
###############################################################################################

https://phoenixnap.com/kb/setup-install-squid-proxy-server-ubuntu


sudo apt-get update

sudo apt-get install squid

sudo vi /etc/squid/squid.conf

# Find "/http_access and change to "http_access allow all"
# Find "/http_access deny all" and comment it
# Tip: press "/" then type http_access, use "n" for next word

sudo systemctl restart squid

sudo squid -k debug

sudo tail -100f /var/log/squid/cache.log
sudo tail -100f /var/log/squid/access.log


###############################################################################################
# Set proxy at client machine
###############################################################################################

env | grep proxy

export https_proxy=http://10.0.2.4:3128
export http_proxy=http://10.0.2.4:3128

export https_proxy=""
export http_proxy=""

###############################################################################################
# Set the Proxy for APT, The apt command requires a separate proxy configuration file on some systems because it does not use system environment variables.
###############################################################################################

sudo touch /etc/apt/apt.conf.d/proxy.conf
sudo vi /etc/apt/apt.conf.d/proxy.conf

## Add following line
Acquire::http::Proxy "http://10.0.2.4:3128";
Acquire::https::Proxy "http://10.0.2.4:3128";

 