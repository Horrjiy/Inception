_This project has been created as part of the 42 curriculum by mpoplow_

# USER DOCUMENTATION

Welcome to Inception! This guide will help you understand, start, stop, and maintain your WordPress website infrastructure.

---

## Overview: What Services Are Running?

Your Inception project runs three main services that work together:

### 1. **NGINX** (Web Server)
   - Handles all incoming HTTPS (secure) web traffic on port 443
   - Acts as a reverse proxy, directing requests to WordPress
   - Manages SSL/TLS encryption for secure connections

### 2. **WordPress** (Website Content Management)
   - The platform where you create posts, pages, and manage your website
   - Runs PHP code to generate dynamic website content
   - Stores all your posts, pages, and media files
   - Communicates with the database to save and retrieve content

### 3. **MariaDB** (Database)
   - Stores all WordPress data: posts, pages, users, settings, and media metadata
   - Runs silently in the background
   - Only WordPress and authorized users can access it

All three services communicate securely through a private Docker network and automatically restart if they fail.

---

## Getting Started: Before You Begin

### Prerequisites
- Docker and Docker Compose must be installed on your machine
- Basic command-line (terminal) knowledge

### Step 1: Create the Environment Configuration File

Before starting the project, you must create a `.env` file in the `srcs/` directory with your credentials.

**Location:** `srcs/.env`

**What to do:**
1. Open a terminal and navigate to your project directory
2. Create the file: `cp srcs/.env.example srcs/.env` (if an example exists)
3. Edit `srcs/.env` with a text editor
4. Fill in all required values (see "Credentials" section below)

---

## Starting and Stopping the Project
**Using the Makefile :**

### Start the Project
```bash
make
```

### Stop the Project
```bash
make down
```

---

## Verifying the Project Is Running Healthy
Method 1: Check Container Status. 
You should see three running containers
```bash
docker ps
```

Method 2: Check Service Health.
View logs for all services:
```bash
docker compose -f srcs/docker-compose.yml logs
```

View logs for a specific service (e.g., WordPress):
```bash
docker compose -f srcs/docker-compose.yml logs wordpress
```

View MariaDB health specifically:
```bash
docker compose -f srcs/docker-compose.yml ps
```

Method 3: Access Your Website
Open a web browser
Go to https://localhost:443 (or simply https://localhost)
You should see your WordPress website
If you see the WordPress login page or your website content, everything is working!

## Credentials: Where to Find and Edit Them
Location
All credentials are stored in a single file: .env

The environment variables are:

_Root password of the Mariadb root user:_  
MDB_ROOT_PASSWORD

_Name of the Mariadb user:_  
MDB_USER

_Pawword of the Mariadb user:_  
MDB_PASSWORD

_Name of the Database:_  
MDB_DATABASE

_Name of the Host:_  
DBHOST

_Name of the Wordpress user:_  
WPAD_USER

_Email of the Wordpress user:_  
WPAD_EMAIL

_Password of the Wordpress user:_  
WPAD_PASSWORD

_Password of of the second Wordpress user:_  
ZWEIER_PASSWORD

Troubleshooting
Won't start? Check .env exists
Can't access? Wait 10 seconds, check docker ps
Database error? Check passwords match in .env