# Holesail Docker
```
 _   _       _                 _ _   _       
| | | | ___ | | ___  ___  __ _(_) | (_) ___  
| |_| |/ _ \| |/ _ \/ __|/ _` | | | | |/ _ \ 
|  _  | (_) | |  __/\__ \ (_| | | |_| | (_) |
|_| |_|\___/|_|\___||___/\__,_|_|_(_)_|\___/ 
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
docker compose up holesail-server -d

# Get the connection string from logs
docker logs holesail-server

# View logs
docker compose logs -f holesail-server
```

**For Docker Compose V1 (Legacy):**
```bash
# Start the server
docker-compose up holesail-server -d

# Get the connection string from logs
docker logs holesail-server

# View logs
docker-compose logs -f holesail-server
```

### Manual Docker Commands

```bash
# Build the image
docker build -t holesail .

# Run server
docker run -d \
  --name holesail-server \
  -p 8090:8090 \
  holesail:latest node bin/holesail.mjs --live 8090

# Check logs for connection string
docker logs holesail-server
```

## Connecting to Holesail Server

After starting the Docker server, you'll get a connection string from the logs. Use this to connect:

```bash
# Connect from another machine with Holesail installed
holesail <connection-string> --port 9090
```

Then access the tunneled application at http://localhost:9090

## Exposing Local Applications

To expose a local web server (e.g., running on localhost:3000), modify the docker-compose.yml command:

```yaml
command: ["node", "bin/holesail.mjs", "--live", "8090", "--host", "host.docker.internal", "--port", "3000"]
extra_hosts:
  - "host.docker.internal:host-gateway"
```

## Docker Compose Commands

**For Docker Compose V2 (Current):**
```bash
# Start server
docker compose up holesail-server -d

# Stop server
docker compose down

# View logs
docker logs holesail-server

# Check running containers
docker ps
```

**For Docker Compose V1 (Legacy):**
```bash
# Start server
docker-compose up holesail-server -d

# Stop server
docker-compose down

# View logs
docker logs holesail-server

# Check running containers
docker ps
```

## URL Format

Holesail uses a simple URL format for sharing server locations:

- Secure server: hs://s000<key>
- Insecure server: hs://0000<key>

## Documentation

Documentation for Holesail can be found at https://docs.holesail.io/

## License

Holesail Server is released under the GPL-3.0 License. See the [LICENSE](https://www.gnu.org/licenses/gpl-3.0.en.html) file for more information.

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.

## Acknowledgments

Holesail is built on and inspired by following open-source projects:

- hypertele: https://github.com/bitfinexcom/hypertele
- holepunch: https://holepunch.to
