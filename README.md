docker build -t mihir012012/mailhog-image:latest .


docker tag mihir012012/mailhog-image:latest mihir012012/mailhog-image:latest


docker push mihir012012/mailhog-image:latest


docker run -d -p 1025:1025 -p 8025:8025 mihir012012/mailhog-image