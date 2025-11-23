FROM node:18-slim AS builder
WORKDIR /usr/src/app

# Install git and libsodium-dev
RUN if command -v apt-get >/dev/null; then \
  apt-get update && apt-get install -y --no-install-recommends git libsodium-dev ca-certificates && \
  rm -rf /var/lib/apt/lists/*; \
  elif command -v apk >/dev/null; then \
  apk add --no-cache git libsodium-dev ca-certificates; \
  elif command -v dnf >/dev/null; then \
  dnf install -y git libsodium-devel ca-certificates && dnf clean all; \
  elif command -v yum >/dev/null; then \
  yum install -y git libsodium-devel ca-certificates && yum clean all; \
  else \
  echo "No supported package manager found! Install git and libsodium manually." && exit 1; \
  fi

RUN git clone https://github.com/holesail/holesail.git .

# Install dependencies
RUN npm install --omit=dev

FROM node:18-slim AS production
WORKDIR /usr/src/app

# Copy from the builder stage
COPY --from=builder /usr/src/app .

# Copy the run script
COPY run.sh /usr/src/app/run.sh

# Make run script executable
RUN chmod +x /usr/src/app/run.sh

# Create non-root user
RUN useradd --uid 1001 --create-home holesail && \
  chown -R holesail:holesail /usr/src/app

USER holesail

# Expose single port instead of range
EXPOSE 8090

# Use the run script as entrypoint
ENTRYPOINT ["/usr/src/app/run.sh"]
