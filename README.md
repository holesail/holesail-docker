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

This Docker setup uses environment variables for configuration with a `run.sh` script that automatically converts them to command-line arguments.

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
```bash
# Build the image
docker build -t holesail .
# Run server with environment variables
docker run -d \
  --name holesail \
  -p 8090:8090 \
  -e HOLESAIL_LIVE_PORT=8090 \
  holesail:latest
# Check logs for key
docker logs holesail | grep "Connect with key:"
```

## Environment Variables Configuration

The Docker setup supports flexible configuration through environment variables:

### Server Mode Variables:
- `HOLESAIL_LIVE_PORT`: Port to host the service on (default: 8090)
- `HOLESAIL_HOST`: Host to bind to
- `HOLESAIL_KEY`: Custom server key
- `HOLESAIL_SEED`: Seed value for key generation
- `HOLESAIL_PUBLIC`: Set to "true" for public access
- `HOLESAIL_DIRECTORY`: Directory to serve files from

### Client Mode Variables:
- `HOLESAIL_CONNECT_KEY`: Server key to connect to (enables client mode)
- `HOLESAIL_PORT`: Local port for client connection

### General Variables:
- `NODE_ENV`: Set to "production" for production deployments
- `HOLESAIL_LOG_LEVEL`: Controls logging verbosity (info, debug, warn, error)
- `HOLESAIL_BUFFERING`: Set to "false" to disable buffering
- `HOLESAIL_CONNECTOR_PORT`: Custom connector port

## Connecting to Holesail Server

### Option 1: Using External Holesail CLI
After starting the Docker server, you'll get a key from the logs. Use this to connect:
```bash
# Get the connection key
docker compose logs --no-log-prefix holesail | grep "hs://"

# Connect from another machine with Holesail installed
holesail <key> --port 9090
```
Then access the tunneled application at http://localhost:9090

### Option 2: Using Docker Client Service
Set up environment variable and start the client container:

```bash
# Set the key from server logs
export HOLESAIL_SERVER_KEY="hs://your-key-here"

# Start client service
docker compose --profile client up holesail-client -d

# View client logs
docker compose logs --no-log-prefix -f holesail-client
```

**Using .env file (Alternative):**
Create a `.env` file in the same directory as docker-compose.yml:
```
HOLESAIL_SERVER_KEY=hs://your-key-here
```
Then start the client:
```bash
docker compose --profile client up holesail-client -d
```

## Exposing Local Applications
To expose a local web server (e.g., running on localhost:3000), use environment variables:
```yaml
holesail:
  # ... other configuration
  environment:
    - HOLESAIL_LIVE_PORT=8090
    - HOLESAIL_HOST=host.docker.internal
    - HOLESAIL_DIRECTORY=/path/to/serve
  extra_hosts:
    - "host.docker.internal:host-gateway"
```

## Docker Compose Commands

**For Docker Compose V2 (Current):**
```bash
# Start server only
docker compose up holesail -d

# Start both server and client
docker compose --profile client up -d

# Stop all services
docker compose down

# Stop and remove volumes
docker compose down -v

# View server logs (clean output)
docker logs holesail
docker compose logs --no-log-prefix holesail

# View client logs (if running)
docker compose logs --no-log-prefix holesail-client

# Get connection key quickly
docker compose logs --no-log-prefix holesail | grep "hs://"

# Check running containers
docker ps
```

**For Docker Compose V1 (Legacy):**
```bash
# Start server only
docker-compose up holesail -d

# Start both server and client
docker-compose --profile client up -d

# Stop all services
docker-compose down

# Stop and remove volumes
docker-compose down -v

# View server logs
docker logs holesail

# View client logs (if running)
docker logs holesail-client

# Get connection key quickly
docker logs holesail | grep "hs://"

# Check running containers
docker ps
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

### Log Configuration:
The docker-compose.yml includes log rotation to prevent excessive disk usage:
```yaml
logging:
  options:
    labels: "service=holesail"
```

## Project Structure
```
.
├── Dockerfile
├── docker-compose.yml
├── run.sh                 # Environment variable parser script
└── README.md
```

The `run.sh` script automatically converts environment variables to command-line arguments, making the Docker setup much more flexible and maintainable.

## Environment Variables Examples

### Server Examples:
```yaml
environment:
  - HOLESAIL_LIVE_PORT=8090
  - HOLESAIL_HOST=localhost
  - HOLESAIL_PUBLIC=true
```

### Client Examples:
```yaml
environment:
  - HOLESAIL_CONNECT_KEY=hs://s000your-key-here
  - HOLESAIL_PORT=9090
```

## URI Format
Holesail uses a simple URI format for sharing server locations:
- Secure server: hs://s000<key>
- Insecure server: hs://0000<key>

## Troubleshooting

### Common Issues:
- **Client won't connect**: Ensure `HOLESAIL_SERVER_KEY` is set correctly with the full key from server logs
- **Can't access local app**: Make sure `extra_hosts` is configured and environment variables are set properly
- **Permission errors**: Check that volumes have proper permissions
- **Verbose logs**: Use `docker compose logs --no-log-prefix holesail` for cleaner output

### Debugging:
```bash
# Check if services are running
docker ps

# View detailed logs without prefix noise
docker compose logs --no-log-prefix -f holesail
docker compose logs --no-log-prefix -f holesail-client

# Check network connectivity
docker network ls
docker network inspect holesail-docker_holesail-network

# Debug the run.sh script execution
docker compose logs --no-log-prefix holesail | grep "Starting holesail with"
```

## Documentation
Documentation for Holesail can be found at https://docs.holesail.io/

## License
Holesail Server is released under the GPL-3.0 License. See the [LICENSE](https://www.gnu.org/licenses/gpl-3.0.en.html) file for more information.

## Contributing
Contributions are welcome! If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.

## Acknowledgments
Holesail is built on and inspired by the following open-source projects:
- hypertele: https://github.com/bitfinexcom/hypertele
- holepunch: https://holepunch.to
