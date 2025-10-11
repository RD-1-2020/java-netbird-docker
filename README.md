# Java NetBird Docker

Docker image combining Amazon Corretto Java 24 and NetBird VPN client.

https://hub.docker.com/repository/docker/dmitriiazurecloud/java-netbird-docker/

## Description

This image is based on:
- `amazoncorretto:24.0.2-alpine3.22` - Amazon Corretto Java 24
- `netbirdio/netbird:0.59.5` - NetBird VPN client

The image allows running Java applications with automatic connection to NetBird VPN network.

## Docker Hub

Image is available at: `dmitriiazurecloud/java-netbird-docker`

```bash
docker pull dmitriiazurecloud/java-netbird-docker:latest
```

## Environment Variables

### NetBird
- `NB_MANAGEMENT_URL` - NetBird management server URL
- `NB_SETUP_KEY` - NetBird setup key
- `NB_HOSTNAME` - (Optional) Hostname for NetBird
- `NB_LOG_LEVEL` - (Default: `info`) NetBird log level

### Java
- `JAVA_OPTS` - Additional JVM parameters
- `APP_OPTS` - Application parameters

## Usage

### Basic Example

```bash
docker run -d \
  --name my-java-app \
  --cap-add=NET_ADMIN \
  -e NB_MANAGEMENT_URL="https://api.netbird.io:443" \
  -e NB_SETUP_KEY="your-setup-key-here" \
  -e JAVA_OPTS="-Xmx512m" \
  -v $(pwd)/app.jar:/app/app.jar \
  dmitriiazurecloud/java-netbird-docker:latest \
  java -jar /app/app.jar
```

### With docker-compose

```yaml
version: '3.8'

services:
  java-app:
    image: dmitriiazurecloud/java-netbird-docker:latest
    container_name: my-java-app
    cap_add:
      - NET_ADMIN
    environment:
      - NB_MANAGEMENT_URL=https://api.netbird.io:443
      - NB_SETUP_KEY=your-setup-key-here
      - NB_HOSTNAME=my-java-app
      - NB_LOG_LEVEL=info
      - JAVA_OPTS=-Xmx512m -Xms256m
    volumes:
      - ./app.jar:/app/app.jar
    command: java -jar /app/app.jar
    restart: unless-stopped
```

### Without NetBird

If you don't need NetBird, simply omit the `NB_SETUP_KEY` and `NB_MANAGEMENT_URL` variables:

```bash
docker run -d \
  --name my-java-app \
  -v $(pwd)/app.jar:/app/app.jar \
  dmitriiazurecloud/java-netbird-docker:latest \
  java -jar /app/app.jar
```

## Building the Image

```bash
docker build -t dmitriiazurecloud/java-netbird-docker:1.0.0 .
```

## Publishing the Image

### Linux/macOS

Change version in DockerFile and in publish.sh.

```bash
./publish.sh
```

## Requirements

- Docker Engine with multi-stage builds support
- For NetBird: `--cap-add=NET_ADMIN` capability

## License

See the [LICENSE](LICENSE) file

## Links

- [Amazon Corretto](https://aws.amazon.com/corretto/)
- [NetBird](https://netbird.io/)
- [Docker Hub Repository](https://hub.docker.com/r/dmitriiazurecloud/java-netbird-docker)

