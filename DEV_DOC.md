_This project has been created as part of the 42 curriculum by mpoplow_

# DEVELOPER DOCUMENTATION

Welcome to the Inception developer guide. This documentation explains the project architecture, how to build and modify services, and the development workflow.

---

## Project Structure

```
inception/
├── Makefile                    # Commands to manage the project (up, down, clean)
├── README.md                   # Project overview and Docker concepts
├── USER_DOC.md                 # End-user guide for running the project
├── DEV_DOC.md                  # This file - developer guide
├── srcs/
│   ├── docker-compose.yml      # Service definitions and configuration
│   ├── .env.example            # Example environment variables template
│   └── requirements/
│       ├── mariadb/
│       │   ├── Dockerfile      # MariaDB container configuration
│       │   └── script.sh        # Initialization script for database setup
│       ├── nginx/
│       │   ├── Dockerfile      # NGINX container configuration
│       │   └── conf/
│       │       └── nginx.config # NGINX server configuration
│       └── wordpress/
│           ├── Dockerfile      # WordPress + PHP-FPM container
│           ├── script.sh        # WordPress initialization script
│           └── conf/
│               └── www.conf     # PHP-FPM pool configuration
```

---

## Docker Compose Overview

The `srcs/docker-compose.yml` file defines three interconnected services:

### Services Architecture

**MariaDB Service**
- Container name: `mariadb`
- Image: Built from `requirements/mariadb/Dockerfile`
- Volumes: Bind mount at `/home/mpoplow/data/mariadb`
- Network: Connected to `mpoplow_network`
- Health check: MySQL ping every 30 seconds
- Environment: Database credentials from `.env`

**WordPress Service**
- Container name: `wordpress`
- Image: Built from `requirements/wordpress/Dockerfile`
- Volumes: Bind mount at `/home/mpoplow/data/wordpress`
- Network: Connected to `mpoplow_network`
- Dependencies: Waits for MariaDB health check before starting
- Environment: Database and admin credentials from `.env`

**NGINX Service**
- Container name: `nginx`
- Image: Built from `requirements/nginx/Dockerfile`
- Ports: Exposes 443 (HTTPS) to host
- Volumes: Shares WordPress files at `/var/www/html`
- Network: Connected to `mpoplow_network`
- Dependencies: Waits for WordPress to start

### Custom Docker Network

All services communicate via `mpoplow_network` (custom bridge network):
- Services can reference each other by container name
- Example: WordPress connects to database via hostname `mariadb` (not localhost)
- Isolated from external networks for security

---

## Understanding the Dockerfiles

### MariaDB Dockerfile

Typically:
- Base image: `mariadb:latest` or specific version
- Installs: Database server and required utilities
- Runs: `script.sh` for initialization
- Sets working directory: `/var/lib/mysql` (data directory)

The `script.sh` creates:
- Database user with credentials
- Initial database from environment variables

### WordPress Dockerfile

Typically:
- Base image: `debian:bookworm` (Debian-based Linux)
- Installs: PHP-FPM, WordPress core, required PHP extensions
- Configures: PHP-FPM pool settings from `www.conf`
- Runs: `script.sh` for WordPress setup
- Exposes: Port 9000 (FastCGI for NGINX communication)

The `script.sh` initializes:
- WordPress configuration (`wp-config.php`)
- Admin user account
- Database connection settings

### NGINX Dockerfile

Typically:
- Base image: `debian:bookworm` or `nginx:latest`
- Installs: NGINX web server, SSL tools
- Configures: Server blocks from `nginx.config`
- Sets up: HTTPS certificates and reverse proxy rules

The `nginx.config`:
- Listens on port 443 (HTTPS)
- Proxies requests to WordPress via FastCGI
- Handles SSL/TLS encryption
- Manages static file serving

---

## Environment Variables Configuration

### Location
`srcs/.env` (create from `.env.example`)

### Variables Explained

| Variable | Used By | Purpose |
|----------|---------|---------|
| `MDB_ROOT_PASSWORD` | MariaDB | Root user password for database administration |
| `MDB_USER` | MariaDB, WordPress | Database username for WordPress connection |
| `MDB_PASSWORD` | MariaDB, WordPress | Password for the database user |
| `MDB_DATABASE` | MariaDB, WordPress | Database name to create and use |
| `DBHOST` | WordPress | Database hostname (should be `mariadb` for Docker) |
| `WPAD_USER` | WordPress | WordPress admin username |
| `WPAD_EMAIL` | WordPress | WordPress admin email |
| `WPAD_PASSWORD` | WordPress | WordPress admin password |
| `ZWEIER_PASSWORD` | WordPress | Secondary WordPress user password |

### How to Create .env

```bash
cp srcs/.env.example srcs/.env
# Edit srcs/.env and fill in values
```

---

## Development Workflow

### Building and Running

**Start with rebuild (detects changes in Dockerfiles):**
```bash
make up
```

**Or manually:**
```bash
docker compose -f srcs/docker-compose.yml up --build
```

**Start without rebuild (faster for testing):**
```bash
docker compose -f srcs/docker-compose.yml up
```

### Accessing Running Containers

**Open shell in a container:**
```bash
docker exec -it wordpress bash      # WordPress container
docker exec -it mariadb bash        # MariaDB container
docker exec -it nginx bash          # NGINX container
```

**View real-time logs:**
```bash
docker compose -f srcs/docker-compose.yml logs -f wordpress
```

### Modifying Services

**After editing a Dockerfile:**
```bash
make down
make up  # Rebuilds images automatically
```

**After editing configuration files (nginx.config, www.conf):**
```bash
docker compose -f srcs/docker-compose.yml up --build
```

**To rebuild without running:**
```bash
docker compose -f srcs/docker-compose.yml build
```

---

## Common Development Tasks

### Accessing the Database

**From inside WordPress container:**
```bash
docker exec -it wordpress mysql -h mariadb -u <MDB_USER> -p<MDB_PASSWORD> <MDB_DATABASE>
```

**From host machine (if MySQL client installed):**
```bash
mysql -h 127.0.0.1 -u <MDB_USER> -p<MDB_PASSWORD> <MDB_DATABASE>
```

### Viewing WordPress Files

**On host machine:**
```bash
ls -la /home/mpoplow/data/wordpress/
# Shows wp-content/, wp-config.php, themes, plugins, etc.
```

**Inside WordPress container:**
```bash
docker exec -it wordpress ls -la /var/www/html/
```

### Checking Service Dependencies

**MariaDB must be healthy before WordPress starts:**
```bash
docker compose -f srcs/docker-compose.yml ps
# Look for MariaDB status column
```

**WordPress must be running before NGINX routes to it:**
```bash
docker compose -f srcs/docker-compose.yml logs nginx
# Check for connection errors
```

---

## Debugging Tips

### Service Won't Start?

1. Check logs:
```bash
docker compose -f srcs/docker-compose.yml logs <service_name>
```

2. Check environment variables:
```bash
docker exec -it wordpress env | grep MDB
```

3. Test connectivity between services:
```bash
docker exec -it wordpress ping mariadb
```

### Port Already in Use?

NGINX uses port 443. If it's busy:
```bash
# Find what's using port 443
sudo lsof -i :443

# Change in docker-compose.yml or kill the process
```

### Data Directory Issues

```bash
# Check permissions
ls -la /home/mpoplow/data/

# Recreate if corrupted
make fclean  # WARNING: Deletes all data
make up      # Starts fresh
```

---

## Building Custom Images

### Modifying Dockerfiles

Edit the Dockerfile in `requirements/service_name/Dockerfile`, then rebuild:
```bash
docker compose -f srcs/docker-compose.yml build <service_name>
docker compose -f srcs/docker-compose.yml up
```

### Adding Dependencies

Example (adding a PHP extension to WordPress):

1. Edit `requirements/wordpress/Dockerfile`
2. Add: `RUN apt-get install -y php-<extension>`
3. Rebuild: `docker compose -f srcs/docker-compose.yml build wordpress`

### Testing Configuration Changes

**NGINX config changes:**
```bash
docker exec -it nginx nginx -t  # Test syntax
docker compose -f srcs/docker-compose.yml restart nginx
```

**PHP-FPM config changes:**
```bash
docker exec -it wordpress php-fpm -t  # Test syntax
docker compose -f srcs/docker-compose.yml restart wordpress
```

---

## Data Persistence

### Bind Mounts

Both services use bind mounts (not Docker-managed volumes):
- **MariaDB:** `/home/mpoplow/data/mariadb` → `/var/lib/mysql`
- **WordPress:** `/home/mpoplow/data/wordpress` → `/var/www/html`

**Advantages:**
- Direct access to files on host
- Easy to backup
- Survives container deletion
- Can be edited directly on host

**When data is lost:**
```bash
make fclean  # Deletes /home/mpoplow/data completely
make up      # Fresh start with empty databases
```

---

## Cleaning Up

**Stop and remove containers:**
```bash
make down
```

**Full cleanup (delete images and data):**
```bash
make fclean
```

**Rebuild from scratch:**
```bash
make re
```

---

## Makefile Commands Reference

| Command | Purpose |
|---------|---------|
| `make up` | Start services and rebuild if needed |
| `make down` | Stop all services |
| `make reup` | Stop and restart services |
| `make fclean` | Delete everything (containers, images, volumes, data) |
| `make re` | Full clean restart |
| `make` | Alias for `make up` |

---

## Troubleshooting Build Issues

**Dockerfile not rebuilding:**
```bash
docker compose -f srcs/docker-compose.yml build --no-cache <service>
```

**Image layer cache issues:**
```bash
docker system prune -a  # Remove all unused images
docker compose -f srcs/docker-compose.yml build
```

**Permission denied errors:**
```bash
# Check data directory ownership
sudo chown -R $USER:$USER /home/mpoplow/data/
```
