
FROM node:18 AS base

WORKDIR /usr/src/app

RUN if command -v apt-get >/dev/null; then \
  apt-get update && apt-get install -y --no-install-recommends libsodium-dev && \
  rm -rf /var/lib/apt/lists/*; \
  elif command -v apk >/dev/null; then \
  apk add --no-cache libsodium-dev; \
  elif command -v dnf >/dev/null; then \
  dnf install -y libsodium-devel && dnf clean all; \
  elif command -v yum >/dev/null; then \
  yum install -y libsodium-devel && yum clean all; \
  else \
  echo "No supported package manager found! Install libsodium manually." && exit 1; \
  fi

# Copy only package files for better caching
COPY package.json package-lock.json* ./

# Install dependencies (excluding dev)
RUN npm install --omit=dev

# Copy rest of the app
COPY . .

# Create non-root user
RUN useradd --uid 1001 --create-home holesail && \
  chown -R holesail:holesail /usr/src/app

USER holesail

EXPOSE 8000-9000

CMD ["node", "index.js"]
