#!/bin/bash

# Default values
DEFAULT_PORT="8090"
DEFAULT_LOG_LEVEL="info"

# Build command arguments from environment variables
ARGS=()

# Handle different modes based on environment variables
if [ -n "$HOLESAIL_CONNECT_KEY" ]; then
    # Client mode - connecting to a server
    ARGS+=("--connect" "$HOLESAIL_CONNECT_KEY")

    # Set port for client
    if [ -n "$HOLESAIL_PORT" ]; then
        ARGS+=("--port" "$HOLESAIL_PORT")
    elif [ -n "$HOLESAIL_CLIENT_PORT" ]; then
        ARGS+=("--port" "$HOLESAIL_CLIENT_PORT")
    else
        ARGS+=("--port" "$DEFAULT_PORT")
    fi

elif [ -n "$HOLESAIL_LIVE_PORT" ]; then
    # Server mode - hosting a service
    ARGS+=("--live" "$HOLESAIL_LIVE_PORT")

elif [ -n "$HOLESAIL_PORT" ]; then
    # Generic port mode
    ARGS+=("--live" "$HOLESAIL_PORT")

else
    # Default server mode
    ARGS+=("--live" "$DEFAULT_PORT")
fi

# Add optional arguments based on environment variables
if [ -n "$HOLESAIL_HOST" ]; then
    ARGS+=("--host" "$HOLESAIL_HOST")
fi

if [ -n "$HOLESAIL_KEY" ]; then
    ARGS+=("--key" "$HOLESAIL_KEY")
fi

if [ -n "$HOLESAIL_SEED" ]; then
    ARGS+=("--seed" "$HOLESAIL_SEED")
fi

if [ "$HOLESAIL_PUBLIC" = "true" ]; then
    ARGS+=("--public")
fi

if [ "$HOLESAIL_BUFFERING" = "false" ]; then
    ARGS+=("--no-buffering")
fi

if [ "$HOLESAIL_QUIET" = "true" ]; then
    ARGS+=("--quiet")
fi

if [ -n "$HOLESAIL_CONNECTOR_PORT" ]; then
    ARGS+=("--connector-port" "$HOLESAIL_CONNECTOR_PORT")
fi

if [ -n "$HOLESAIL_DIRECTORY" ]; then
    ARGS+=("--directory" "$HOLESAIL_DIRECTORY")
fi

# Set log level
if [ -n "$HOLESAIL_LOG_LEVEL" ]; then
    case "$HOLESAIL_LOG_LEVEL" in
    "debug" | "info" | "warn" | "error")
        export LOG_LEVEL="$HOLESAIL_LOG_LEVEL"
        ;;
    *)
        echo "Warning: Invalid log level '$HOLESAIL_LOG_LEVEL', using default 'info'"
        export LOG_LEVEL="info"
        ;;
    esac
else
    export LOG_LEVEL="$DEFAULT_LOG_LEVEL"
fi

# Print the command for debugging (optional)
if [ "$HOLESAIL_DEBUG" = "true" ]; then
    echo "Starting holesail with arguments: ${ARGS[*]}"
fi

# Execute the holesail command
if [ "$HOLESAIL_QUIET" = "true" ]; then
    # Start holesail and filter out ASCII art/banner lines
    node bin/holesail.mjs "${ARGS[@]}" 2>&1 |
        grep -v -E "█|│|└|┌|▄|▀|┐|┘|═|╗|╚|╝|╔|║|░|▒|▓|■|□|▪|▫|◄|►|▲|▼|◆|◇|○|●|◯|★|☆|♠|♣|♥|♦" |
        grep -v -E "^\s*$|Connection Mode:|Holesail.*Started|listening on|Connect with key:|NOTE.*TREAT.*SSH" &

    # Keep the process running
    wait
else
    exec node bin/holesail.mjs "${ARGS[@]}"
fi
