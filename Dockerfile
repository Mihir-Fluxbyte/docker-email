# Use the official Node.js image as base
FROM node:latest

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

# Expose MailHog and Node.js ports
EXPOSE 1025 8025 8000

# Start MailHog and your Node.js application concurrently with NGINX
CMD mailhog -api-bind-addr 0.0.0.0:8025 -smtp-bind-addr 0.0.0.0:1025  & node index.js & nginx -g 'daemon off;'
