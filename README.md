# Holesail Docker
```
 _   _       _                 _ _ 
| | | | ___ | | ___  ___  __ _(_) |
| |_| |/ _ \| |/ _ \/ __|/ _` | | |
|  _  | (_) | |  __/\__ \ (_| | | |
|_| |_|\___/|_|\___||___/\__,_|_|_|
```
[Join our Discord Support Server](https://discord.gg/TQVacE7Vnj) [Join our Reddit Community](https://www.reddit.com/r/holesail/)

To support the development of this project:
Lightning BTC: linenbird5@primal.net
BTC Address: 183Pfn4fxuMJMSvZXdBdYsNKWSnWHCdBdA

## Overview
Holesail is a truly peer-to-peer network tunneling and reverse proxy software that supports both TCP and UDP protocols.

Holesail lets you share any locally running application on a specific port with third parties securely and with a single command. No static IP or port forwarding required.

## Docker Installation

### Using Docker Compose (Recommended)

This Docker setup uses environment variables with explicit `MODE` configuration for clear server/client/filemanager operation.

**For Docker Compose V2 (Current):**
```bash
# Start the server
docker compose up holesail -d

# Get the key from logs (clean output)
docker compose logs --no-log-prefix holesail | grep "Connect with key:"

# View logs without service prefix
docker compose logs --no-log-prefix -f holesail
```

**For Docker Compose V1 (Legacy):**
```bash
# Start the server
docker-compose up holesail -d

# Get the key from logs
docker logs holesail | grep "Connect with key:"

# View logs
docker-compose logs -f holesail
```

### Manual Docker Commands

**Server Mode:**
```bash
docker run -d --name holesail \
  -e MODE=server \
  -e PORT=25565 \
  -e HOST=127.0.0.1 \
  -e KEY=very-super-secret \
  -e PUBLIC=false \
  --network host \
  holesail:latest
```

**Client Mode:**
```bash
docker run -d --name holesail-client \
  -e MODE=client \
  -e PORT=25565 \
  -e HOST=127.0.0.1 \
  -e KEY=very-super-secret \
  -e FORCE=true \
  -e LOG=true \
  --network host \
  holesail:latest
```

**File Manager Mode:**
```bash
docker run -d \
  --name holesail-filemanager \
  -p 8080:8080 \
  -e MODE=filemanager \
  -e PORT=8080 \
  -e HOST=127.0.0.1 \
  -e PUBLIC=true \
  -e LOG=true \
  -e KEY=my-filemanager-key \
  -e FORCE=true \
  -e DIR=/app/files \
  -e USERNAME=admin \
  -e PASSWORD=securepass \
  -e ROLE=admin \
  -v /path/to/local/files:/app/files \
  holesail:latest
```

## Environment Variables Configuration

The Docker setup uses a simple `MODE` variable to determine operation mode, with consistent variable names across all modes:

### Core Variables (All Modes):
- `MODE`: Operation mode (`server`, `client`, or `filemanager`)
- `PORT`: Port number for the service
- `HOST`: Host to bind to (default: 127.0.0.1)
- `KEY`: Connection key (server key for client mode, custom key for server/filemanager)
- `PUBLIC`: Set to "true" for public access
- `FORCE`: Set to "true" to force operation
- `LOG`: Set to "true" or log level for logging

### Server Mode Specific:
- `HOLESAIL_KEY`: Alternative way to set custom server key

### File Manager Mode Specific:
- `DIR`: Directory to serve files from
- `USERNAME`: File manager username
- `PASSWORD`: File manager password
- `ROLE`: User role for file manager

### Advanced Variables:
- `NODE_ENV`: Set to "production" for production deployments
- 
## Usage Examples

### Starting a Server
```bash
# Start server with Docker Compose
docker compose up holesail -d

# Get connection key
docker compose logs --no-log-prefix holesail | grep "Connect with key:"
```

### Connecting a Client
```bash
# Set the key from server logs
export HOLESAIL_KEY="hs://s000your-key-here"

# Start client service
docker compose --profile client up holesail-client -d

# View client logs
docker compose logs --no-log-prefix -f holesail-client
```

### Running File Manager
```bash
# Start file manager service
docker compose --profile filemanager up holesail-filemanager -d

# View file manager logs
docker compose logs --no-log-prefix -f holesail-filemanager
```

## Docker Compose Profiles

The docker-compose.yml supports different profiles for different use cases:

- **Default**: Server only
- **`client`**: Includes client service
- **`filemanager`**: Includes file manager service

```bash
# Start server only (default)
docker compose up holesail -d

# Start server and client
docker compose --profile client up -d

# Start all services including file manager
docker compose --profile client --profile filemanager up -d
```

## Environment File (.env)

Create a `.env` file for easier configuration:
```env
# Server configuration
NODE_ENV=production
MODE=server
PORT=8090
HOST=127.0.0.1
KEY=my-custom-key
PUBLIC=true
LOG=true

# Client configuration (when using client profile)
HOLESAIL_KEY=hs://s000your-server-key-here
```

## Log Management

### Clean Log Viewing:
```bash
# View logs without service name prefix
docker compose logs --no-log-prefix holesail

# Get only the connection key
docker compose logs --no-log-prefix holesail | grep "Connect with key:"

# View logs without QR code noise
docker compose logs --no-log-prefix holesail | grep -v "█"

# View only essential startup info
docker compose logs --no-log-prefix holesail | grep -E "(Started|listening|Connect with key)"
```

## Project Structure
```
.
├── Dockerfile
├── docker-compose.yml
├── run.sh                 # Environment variable parser script
├── README.md
└── files/                 # Directory for file manager (optional)
```

## Troubleshooting

### Common Issues:
- **Client won't connect**: Ensure `KEY` is set correctly with the full key from server logs
- **Can't access local app**: Make sure `extra_hosts` is configured and environment variables are set properly
- **Permission errors**: Check that volumes have proper permissions
- **Mode confusion**: Always set `MODE` explicitly (`server`, `client`, or `filemanager`)

### Debugging:
```bash
# Check if services are running
docker ps

# View detailed logs without prefix noise
docker compose logs --no-log-prefix -f holesail

# Check the exact command being run
docker compose logs --no-log-prefix holesail | grep "Starting holesail with"

# Test different modes
docker run --rm -e MODE=server -e PORT=8080 -e LOG=true holesail:latest
```

## Example Output

**Server startup:**
```
Starting holesail with: node src/bin/holesail.mjs --live 25565 --host 127.0.0.1 --force --key very-super-secret --log
| Connect with key: hs://s000very-super-secret
| Holesail is now listening on 127.0.0.1:25565
```

**File manager startup:**
```
Starting holesail with: node src/bin/holesail.mjs --filemanager /app/files --port 8080 --public --force --host 127.0.0.1 --key my-filemanager-key --username admin --password securepass --role admin --log
| Holesail is now listening on 127.0.0.1:8080
| Username: admin Password: securepass Role: admin
```

## URI Format
Holesail uses a simple URI format:
- Secure server: `hs://s000<key>`
- Insecure server: `hs://0000<key>`

## Documentation
Documentation for Holesail can be found at https://docs.holesail.io/