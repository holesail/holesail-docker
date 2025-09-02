#!/bin/bash

# Build command arguments from environment variables
ARGS=()

# Handle different modes based on environment variables
if [ -n "$HOLESAIL_CLIENT_KEY" ]; then
    # Client mode
    ARGS+=("--connect" "$HOLESAIL_CLIENT_KEY")
    if [ -n "$HOLESAIL_CLIENT_PORT" ]; then
        ARGS+=("--port" "$HOLESAIL_CLIENT_PORT")
    fi
elif [ -n "$HOLESAIL_SERVICE_PORT" ]; then
    # Server mode
    ARGS+=("--live" "$HOLESAIL_SERVICE_PORT")
else
    # Default server mode
    ARGS+=("--live" "8090")
fi

# Add optional arguments based on environment variables
if [ -n "$HOLESAIL_BIND_HOST" ]; then
    ARGS+=("--host" "$HOLESAIL_BIND_HOST")
fi

if [ -n "$HOLESAIL_SERVER_KEY" ]; then
    ARGS+=("--key" "$HOLESAIL_SERVER_KEY")
fi

if [ -n "$HOLESAIL_KEY_SEED" ]; then
    ARGS+=("--seed" "$HOLESAIL_KEY_SEED")
fi

if [ "$HOLESAIL_ENABLE_PUBLIC" = "true" ]; then
    ARGS+=("--public")
fi

if [ "$HOLESAIL_ENABLE_BUFFERING" = "false" ]; then
    ARGS+=("--no-buffering")
fi

if [ -n "$HOLESAIL_CONNECTOR_PORT" ]; then
    ARGS+=("--connector-port" "$HOLESAIL_CONNECTOR_PORT")
fi

if [ -n "$HOLESAIL_FILE_DIRECTORY" ]; then
    ARGS+=("--directory" "$HOLESAIL_FILE_DIRECTORY")
fi

# Debug output
echo "Starting holesail with: node bin/holesail.mjs ${ARGS[*]}"

# Execute the holesail command
exec node bin/holesail.mjs "${ARGS[@]}"
