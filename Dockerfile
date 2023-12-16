# Stage 1: Use the official MailHog image as base
FROM mailhog/mailhog as mailhog

# Expose MailHog ports
EXPOSE 1025 8025

# Stage 2: Use Node.js image as base
FROM node:latest as node

# Create a working directory for the Node.js app
WORKDIR /app

# Copy package.json and package-lock.json (if present)
COPY package*.json ./

# Install Node.js application dependencies
RUN npm install

# Copy your application files into the container
COPY . .

# Expose the port for your Node.js app
EXPOSE 8000

# Start NGINX setup
FROM nginx:latest

# Remove default NGINX configuration
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom NGINX configuration
COPY nginx.conf /etc/nginx/conf.d/

# Copy MailHog binary from the mailhog stage
COPY --from=mailhog /MailHog /usr/local/bin/MailHog

# Copy Node.js app from the node stage
COPY --from=node /app /app

# Expose ports for NGINX, MailHog, and Node.js app
EXPOSE 80 1025 8025 8000

# Command to start NGINX, MailHog, and your Node.js application
CMD service nginx start && MailHog -api-bind-addr 0.0.0.0:8025 -smtp-bind-addr 0.0.0.0:1025 & node /app/index.js
