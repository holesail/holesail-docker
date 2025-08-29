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

# Clone the specific branch
RUN git clone --branch class https://github.com/holesail/holesail.git .

# Install dependencies (excluding dev)
RUN npm install --omit=dev

# Stage 2: Production Stage
FROM node:18-slim AS production

WORKDIR /usr/src/app

# Copy from the builder stage
COPY --from=builder /usr/src/app .

# Create non-root user
RUN useradd --uid 1001 --create-home holesail && \
  chown -R holesail:holesail /usr/src/app

USER holesail

EXPOSE 8000-9000

CMD ["node", "index.js"]
