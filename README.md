_This project has been created as part of the 42 curriculum by mpoplow_

# DESCRIPTION

## Overview
### The Project:
Inception provides a self-contained WordPress website infrastructure, with NGINX handling HTTPS traffic, WordPress/PHP-FPM serving the site, and MariaDB storing its data. The services communicate through a Docker network, while the website files and database persist independently of the containers.

### Docker: 
A platform for building and running applications in isolated, portable containers.

### Docker container: 
An isolated, lightweight environment that packages an application and its dependencies so it can run consistently.

### Docker Compose: 
A tool for defining and managing multi-container applications through a YAML configuration file.

### MariaDB: 
An open-source relational database server used to store and manage structured application data.

### NGINX: 
A web server and reverse proxy that receives HTTP/HTTPS requests and forwards application requests to backend services.

### WordPress: 
A PHP-based content management system used to create and manage websites.

### PHP-FPM: 
A PHP process manager that executes PHP scripts and communicates with web servers such as NGINX.

## Important differences
### Virtual Machines vs Docker
Virtual Machines emulate entire operating systems, requiring significant resources and slow startup times. Docker containers share the host's kernel, running isolated applications with minimal overhead and instant startup, making them lightweight and efficient alternatives to VMs.

### Secrets vs Environment Variables
Environment variables are plaintext values accessible to containers and visible in logs, suitable for non-sensitive configuration. Secrets are encrypted sensitive data (passwords, tokens, keys) with restricted access, designed to keep sensitive information secure and hidden from logs and processes.

### Docker Network vs Host Network
A Docker network is a virtual network created by Docker that allows containers to communicate with each other using container names as hostnames,  while remaining isolated from external networks. It was used in this project because of the isolation and flexibility.
A host network bypasses Docker's networking layer entirely, allowing a container to share the host machine's network stack directly. This means the container uses the host's IP address and ports.

### Docker Volumes vs Bind Mounts
DOCKER VOLUMES are a way to preserve data outside docker containers. Volumes decouple data from the container lifecycle, allowing you to preserve databases, configurations, and user uploads independently, even if the container is deleted.
BIND MOUNTS are a subtype of volumes, mapping a directory from your host machine directly into a container. When the container writes to that mounted path, the changes are immediately visible on your host filesystem.

# INSTRUCTIONS
Find instructions how to use the project in the USER_DOC:  
[User Documentation](USER_DOC.md)

Find Instructions in the DEV_DOC:  
[Developer Documentation](USER_DOC.md)


# RESOURCES
https://docs.docker.com/reference/cli/docker/compose/
https://hub.docker.com/_/mariadb
https://www.debian.org/releases/bookworm/
https://www.nginx.com/resources/wiki/start/
https://www.nginx.com/resources/wiki/start/topics/tutorials/config_pitfalls/
https://wiki.debian.org/Nginx/DirectoryStructure

## AI declaration
AI was mainly used to answer questions and to explain unknown/new concepts. Later it was also used for generating text and spotting bugs.