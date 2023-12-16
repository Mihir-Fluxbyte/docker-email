# Use a base Node.js image
FROM node:latest

# Install MailHog
RUN apt-get update && apt-get install -y mailhog

# Create a working directory for the Node.js app
WORKDIR /app

# Copy package.json and package-lock.json (if present)
COPY package*.json ./

# Install Node.js application dependencies
RUN npm install

# Copy your application files into the container
COPY . .

# Expose ports for MailHog and Node.js app
EXPOSE 1025 8025 8000

# Command to start MailHog and your Node.js application
CMD ["mailhog", "&", "node", "index.js"]
