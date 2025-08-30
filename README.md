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

**For Docker Compose V2 (Current):**
```bash
# Start the server
docker compose up holesail -d
# Get the key from logs
docker logs holesail
# View logs
docker compose logs -f holesail
```

**For Docker Compose V1 (Legacy):**
```bash
# Start the server
docker-compose up holesail -d
# Get the key from logs
docker logs holesail
# View logs
docker-compose logs -f holesail
```

### Manual Docker Commands
```bash
# Build the image
docker build -t holesail .
# Run server
docker run -d \
  --name holesail \
  -p 8090:8090 \
  holesail:latest node bin/holesail.mjs --live 8090
# Check logs for key
docker logs holesail
```

## Connecting to Holesail Server

### Option 1: Using External Holesail CLI
After starting the Docker server, you'll get a key from the logs. Use this to connect:
```bash
# Connect from another machine with Holesail installed
holesail <key> --port 9090
```
Then access the tunneled application at http://localhost:9090

### Option 2: Using Docker Client Service
Set up environment variable and start the client container:

**For Docker Compose V2 (Current):**
```bash
# Set the key from server logs
export HOLESAIL_SERVER_KEY="hs://your-key-here"

# Start client service
docker compose --profile client up holesail-client -d

# View client logs
docker compose logs -f holesail-client
```

**For Docker Compose V1 (Legacy):**
```bash
# Set the key from server logs
export HOLESAIL_SERVER_KEY="hs://your-key-here"

# Start client service
docker-compose --profile client up holesail-client -d

# View client logs
docker-compose logs -f holesail-client
```

**Using .env file (Alternative):**
Create a `.env` file in the same directory as docker-compose.yml:
```
HOLESAIL_SERVER_KEY=hs://your-key-here
```
Then start the client without setting environment variables manually:
```bash
docker compose --profile client up holesail-client -d
```

## Exposing Local Applications
To expose a local web server (e.g., running on localhost:3000), modify the docker-compose.yml command:
```yaml
holesail:
  # ... other configuration
  extra_hosts:
    - "host.docker.internal:host-gateway"
  command: ["node", "bin/holesail.mjs", "--live", "8090", "--host", "host.docker.internal", "--port", "3000"]
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

# View server logs
docker logs holesail

# View client logs (if running)
docker logs holesail-client

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

# Check running containers
docker ps
```

## Environment Variables
- `HOLESAIL_SERVER_KEY`: Key for client to connect to server (required for client service)
- `NODE_ENV`: Set to `production` for production deployments
- `HOLESAIL_LOG_LEVEL`: Controls logging verbosity (`info`, `debug`, `error`)

## URI Format
Holesail uses a simple URI format for sharing server locations:
- Secure server: hs://s000<key>
- Insecure server: hs://0000<key>

## Troubleshooting

### Common Issues:
- **Client won't connect**: Ensure `HOLESAIL_SERVER_KEY` is set correctly with the full key from server logs
- **Can't access local app**: Make sure `extra_hosts` is configured and the target port is correct
- **Permission errors**: Check that volumes have proper permissions

### Debugging:
```bash
# Check if services are running
docker ps

# View detailed logs
docker compose logs -f holesail
docker compose logs -f holesail-client

# Check network connectivity
docker network ls
docker network inspect holesail-docker_holesail-network
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
