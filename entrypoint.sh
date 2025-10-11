#!/bin/bash
set -e

echo "Starting NetBird Java Container..."

# Start NetBird in background mode if connection parameters are specified
if [ -n "$NB_SETUP_KEY" ] && [ -n "$NB_MANAGEMENT_URL" ]; then
    echo "Configuring NetBird..."
    
    # Start netbird up with parameters
    netbird up \
        --setup-key "$NB_SETUP_KEY" \
        --management-url "$NB_MANAGEMENT_URL" \
        ${NB_HOSTNAME:+--hostname "$NB_HOSTNAME"} \
        --log-level "$NB_LOG_LEVEL" \
        --daemon-addr "unix:///var/run/netbird.sock" &
    
    NETBIRD_PID=$!
    echo "NetBird started with PID: $NETBIRD_PID"
    
    # Wait for NetBird connection
    echo "Waiting for NetBird connection..."
    for i in {1..30}; do
        if netbird status &>/dev/null; then
            echo "NetBird connected successfully!"
            break
        fi
        sleep 1
    done
else
    echo "NetBird setup key or management URL not provided. Skipping NetBird initialization."
fi

# Start Java application
echo "Starting Java application..."
exec "$@"

