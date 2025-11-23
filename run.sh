#!/bin/bash

# Build command arguments from environment variables
ARGS=()

# Handle different modes based on MODE environment variable
case "$MODE" in
"server")
  # Server mode
  if [ -n "$PORT" ]; then
    ARGS+=("--live" "$PORT")
  else
    ARGS+=("--live" "8090")
  fi
  ;;
"client")
  # Client mode
  if [ -n "$KEY" ]; then
    ARGS+=("--connect" "$KEY")
  fi
  if [ -n "$PORT" ]; then
    ARGS+=("--port" "$PORT")
  fi
  ;;
"filemanager")
  # Filemanager mode
  if [ -n "$DIR" ]; then
    ARGS+=("--filemanager" "$DIR")
  fi
  if [ -n "$PORT" ]; then
    ARGS+=("--port" "$PORT")
  fi
  if [ -n "$USERNAME" ]; then
    ARGS+=("--username" "$USERNAME")
  fi
  if [ -n "$PASSWORD" ]; then
    ARGS+=("--password" "$PASSWORD")
  fi
  if [ -n "$ROLE" ]; then
    ARGS+=("--role" "$ROLE")
  fi
  ;;
*)
  # Default server mode if MODE not specified
  if [ -n "$PORT" ]; then
    ARGS+=("--live" "$PORT")
  else
    ARGS+=("--live" "8090")
  fi
  ;;
esac

# Add optional arguments based on environment variables
if [ -n "$HOST" ]; then
  ARGS+=("--host" "$HOST")
fi

if [ -n "$KEY" ] && [ "$MODE" != "client" ]; then
  ARGS+=("--key" "$KEY")
fi

if [ -n "$HOLESAIL_KEY" ]; then
  ARGS+=("--key" "$HOLESAIL_KEY")
fi

if [ "$PUBLIC" = "true" ]; then
  ARGS+=("--public")
fi

if [ "$FORCE" = "true" ]; then
  ARGS+=("--force")
fi

if [ "$LOG" = "true" ] || [ "$LOG" = "1" ]; then
  ARGS+=("--log")
elif [ -n "$LOG" ] && [ "$LOG" != "false" ] && [ "$LOG" != "0" ]; then
  ARGS+=("--log" "$LOG")
fi

# Debug output
echo "Starting holesail with: node src/bin/holesail.mjs ${ARGS[*]}"

# Execute the holesail command
exec node src/bin/holesail.mjs "${ARGS[@]}"
