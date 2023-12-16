# Use the official Node.js image as base
FROM node:latest

# Install NGINX, curl, and gnupg2 (needed for MailHog installation)
RUN apt-get update && \
    apt-get install -y nginx curl gnupg2

# Install MailHog
RUN wget -O /usr/local/bin/mailhog https://github.com/mailhog/MailHog/releases/download/v1.0.0/MailHog_linux_amd64 && \
    chmod +x /usr/local/bin/mailhog

# Set up NGINX configuration
RUN mkdir -p /etc/nginx/sites-available && \
    mkdir -p /etc/nginx/sites-enabled

COPY nginx.conf /etc/nginx/nginx.conf

# Set up your Node.js application
WORKDIR /app

# Copy your application files into the container
COPY . .

# Install Node.js application dependencies
RUN npm install

# Expose ports for MailHog, NGINX, and Node.js app
EXPOSE 1025 8025 8000

# Start MailHog, Node.js application, and NGINX concurrently
CMD mailhog -api-bind-addr 0.0.0.0:8025 -smtp-bind-addr 0.0.0.0:1025 & node index.js & nginx -g 'daemon off;'
