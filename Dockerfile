# Use a base image with Node.js
FROM node:latest

# Install NGINX, curl, and gnupg2 (needed for MailHog installation)
RUN apt-get update && \
    apt-get install -y nginx curl gnupg2

# Install MailHog
RUN curl -fsSL https://github.com/mailhog/MailHog/releases/download/v1.0.0/MailHog_linux_amd64.tar.gz | tar -xz -C /usr/local/bin/ && \
    mv /usr/local/bin/MailHog_linux_amd64 /usr/local/bin/mailhog && \
    chmod +x /usr/local/bin/mailhog

# Set up NGINX configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Expose ports for MailHog and Node.js app
EXPOSE 1025 8025 3000

# Set up your Node.js application
WORKDIR /app

# Copy your application files into the container
COPY . .

# Install Node.js application dependencies
RUN npm install

# Build your Node.js application (if required)
# RUN npm run build

# Start NGINX, MailHog, and your Node.js app concurrently
CMD service nginx start & mailhog -api-bind-addr 0.0.0.0:8025 -smtp-bind-addr 0.0.0.0:1025 & node index.js
