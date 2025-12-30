# Docker Deployment Guide

## Quick Start

### Option 1: Using Docker Compose (Recommended for development/testing with local PostgreSQL)

1. Copy environment variables:
   ```bash
   cp .env.docker .env
   # Edit .env with your actual values
   ```

2. Build and run:
   ```bash
   docker-compose up -d
   ```

3. View logs:
   ```bash
   docker-compose logs -f app
   ```

4. Stop containers:
   ```bash
   docker-compose down
   ```

### Option 2: Docker Only (Using existing Neon PostgreSQL)

1. Build the image:
   ```bash
   docker build -t swiftie-sanctuary .
   ```

2. Run the container:
   ```bash
   docker run -d \
     --name swiftie-sanctuary \
     -p 3000:3000 \
     -e NODE_ENV=production \
     -e PORT=3000 \
     -e DB_USER=neondb_owner \
     -e DB_HOST=ep-aged-waterfall-a4o6wlei-pooler.us-east-1.aws.neon.tech \
     -e DB_NAME=SwiftieSanctuary \
     -e DB_PASSWORD=your_password \
     -e DB_PORT=5432 \
     -e SESSION_SECRET=your_secret \
     --restart unless-stopped \
     swiftie-sanctuary
   ```

3. View logs:
   ```bash
   docker logs -f swiftie-sanctuary
   ```

4. Stop container:
   ```bash
   docker stop swiftie-sanctuary
   docker rm swiftie-sanctuary
   ```

## Deploying to Your Server

### Using Docker Hub

1. Tag your image:
   ```bash
   docker tag swiftie-sanctuary yourusername/swiftie-sanctuary:latest
   ```

2. Push to Docker Hub:
   ```bash
   docker push yourusername/swiftie-sanctuary:latest
   ```

3. On your server, pull and run:
   ```bash
   docker pull yourusername/swiftie-sanctuary:latest
   docker run -d \
     --name swiftie-sanctuary \
     -p 3000:3000 \
     --env-file .env \
     --restart unless-stopped \
     yourusername/swiftie-sanctuary:latest
   ```

### Using Docker Compose on Your Server

1. Copy these files to your server:
   - `docker-compose.yml`
   - `.env` (with production values)

2. Run on server:
   ```bash
   docker-compose up -d
   ```

## Environment Variables

Make sure to set these in your `.env` file:

- `DB_USER` - PostgreSQL username
- `DB_HOST` - PostgreSQL host
- `DB_NAME` - Database name
- `DB_PASSWORD` - Database password
- `DB_PORT` - Database port (usually 5432)
- `SESSION_SECRET` - Random string for session encryption
- `NODE_ENV` - Set to "production"
- `PORT` - Port to run on (default 3000)

## Production Tips

1. **Use a reverse proxy** (nginx or Caddy) in front of the container
2. **Set up SSL/TLS** with Let's Encrypt
3. **Use Docker secrets** or a secrets manager for sensitive data
4. **Enable health checks** in your docker-compose.yml
5. **Set up automatic backups** for your PostgreSQL database
6. **Use Docker volumes** for persistent data if running PostgreSQL in Docker

## Troubleshooting

- Check logs: `docker-compose logs -f app`
- Access container: `docker exec -it swiftie-sanctuary sh`
- Rebuild after code changes: `docker-compose up -d --build`
