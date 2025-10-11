# Multi-stage build to combine netbird and Amazon Corretto Java 24
FROM netbirdio/netbird:0.59.5 AS netbird

# Base image with Java 24
FROM amazoncorretto:24.0.2-alpine3.22

# Image metadata
LABEL maintainer="dmitriiazurecloud"
LABEL description="Amazon Corretto Java 24 with NetBird VPN client"
LABEL version="jdk-24.0.2-alpine3.22-netbird-0.59.5"

# Install required dependencies
RUN apk add --no-cache \
    ca-certificates \
    iptables \
    iproute2 \
    wireguard-tools \
    openresolv \
    bash \
    curl \
    && rm -rf /var/cache/apk/*

# Copy netbird binaries from the first stage
COPY --from=netbird /usr/local/bin/netbird /usr/local/bin/netbird

# Ensure /usr/local/bin is in PATH
ENV PATH="/usr/local/bin:${PATH}"

# Create necessary directories
RUN mkdir -p /etc/netbird \
    && mkdir -p /var/log/netbird \
    && mkdir -p /app

# Set working directory
WORKDIR /app

# Environment variables for Java
ENV JAVA_OPTS="" \
    APP_OPTS=""

# Environment variables for NetBird
ENV NB_MANAGEMENT_URL="" \
    NB_SETUP_KEY="" \
    NB_HOSTNAME="" \
    NB_LOG_LEVEL="info"

# Ports (configure for your application)
EXPOSE 8080

# Startup script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["java"]

