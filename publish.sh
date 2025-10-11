#!/bin/bash

# Script to publish Docker image to Docker Hub
# Repository: dmitriiazurecloud/java-netbird-docker

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Settings
DOCKER_USERNAME="dmitriiazurecloud"
VERSION="jdk-24.0.2-alpine3.22-netbird-0.59.5"
IMAGE_NAME="java-netbird-docker"
DOCKER_REGISTRY="docker.io"
FULL_IMAGE_NAME="${DOCKER_USERNAME}/${IMAGE_NAME}"

# Additional tags (e.g., "latest" "stable")
ADDITIONAL_TAGS=("$@")

# Function for output messages
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check if Docker is running
if ! docker info &>/dev/null; then
    log_error "Docker is not running. Please start Docker and try again."
    exit 1
fi

# Check Docker Hub authentication
log_info "Checking Docker Hub authentication..."
if ! docker info | grep -q "Username:"; then
    log_warning "You are not logged in to Docker Hub"
    log_info "Attempting to login..."
    docker login
fi

# Build image
log_info "Building Docker image: ${FULL_IMAGE_NAME}:${VERSION}"
docker build -t "${FULL_IMAGE_NAME}:${VERSION}" .

if [ $? -ne 0 ]; then
    log_error "Docker build failed!"
    exit 1
fi

log_info "Build completed successfully!"

# Tag image
log_info "Tagging image..."
docker tag "${FULL_IMAGE_NAME}:${VERSION}" "${DOCKER_REGISTRY}/${FULL_IMAGE_NAME}:${VERSION}"

# Add additional tags
for tag in "${ADDITIONAL_TAGS[@]}"; do
    log_info "Adding tag: ${tag}"
    docker tag "${FULL_IMAGE_NAME}:${VERSION}" "${DOCKER_REGISTRY}/${FULL_IMAGE_NAME}:${tag}"
done

# Push image
log_info "Pushing image: ${DOCKER_REGISTRY}/${FULL_IMAGE_NAME}:${VERSION}"
docker push "${DOCKER_REGISTRY}/${FULL_IMAGE_NAME}:${VERSION}"

if [ $? -ne 0 ]; then
    log_error "Docker push failed!"
    exit 1
fi

# Push additional tags
for tag in "${ADDITIONAL_TAGS[@]}"; do
    log_info "Pushing tag: ${DOCKER_REGISTRY}/${FULL_IMAGE_NAME}:${tag}"
    docker push "${DOCKER_REGISTRY}/${FULL_IMAGE_NAME}:${tag}"
done

log_info "Successfully published ${FULL_IMAGE_NAME}:${VERSION} to Docker Hub!"
log_info "Available at: https://hub.docker.com/r/${FULL_IMAGE_NAME}"

# Show all published tags
echo ""
log_info "Published tags:"
echo "  - ${DOCKER_REGISTRY}/${FULL_IMAGE_NAME}:${VERSION}"
for tag in "${ADDITIONAL_TAGS[@]}"; do
    echo "  - ${DOCKER_REGISTRY}/${FULL_IMAGE_NAME}:${tag}"
done

