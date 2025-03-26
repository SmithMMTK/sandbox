#!/bin/bash

# Print info
hostname && uptime

# Update
sudo apt-get update -y

# Clean old Node/npm
sudo apt-get remove -y nodejs npm

# Install Node.js 20 from NodeSource (includes npm)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# Verify installation
node -v
npm -v