# Kataria Stone World Admin

A multi-container Docker application with Inventory UI, Website UI, Backend API, and MySQL database, all routed through NGINX reverse proxy.

## Architecture

```
Internet
   │
   ▼
┌──────────────┐
│   NGINX      │  (Reverse Proxy)
│  :80         │
└──────┬───────┘
       │
 ┌─────┼───────────────┐
 │     │               │
 ▼     ▼               ▼
Inventory  Website   Backend
  UI         UI        API
:3001      :3000      :8080
                       │
                       ▼
                     MySQL
                     :3306
```

## Services

- **NGINX** (Port 80): Reverse proxy routing requests to appropriate services
- **Inventory UI** (Port 3001): React-based inventory management interface
- **Website UI** (Port 3000): React-based public website
- **Backend API** (Port 8080): Spring Boot REST API
- **MySQL** (Port 3306): Database server

## Prerequisites

- Docker Engine 20.10+
- Docker Compose 2.0+
- Git

## Quick Start

### 1. Clone the Repository

```bash
git clone <your-repo-url>
cd katariastoneworldadmin
```

### 2. Create Environment File

Create a `.env` file in the project root:

```env
# MySQL Database Configuration
MYSQL_ROOT_PASSWORD=rootpassword123
MYSQL_DATABASE=katariastoneworld
MYSQL_USER=katariauser
MYSQL_PASSWORD=katariapass123

# Backend Configuration (add your Spring Boot config here if needed)
```

### 3. Build and Start Services

```bash
docker compose up -d --build
```

### 4. Verify Services

Check that all containers are running:

```bash
docker compose ps
```

## Access URLs

Once all services are running, access the application at:

- **Website UI**: http://localhost/
- **Inventory UI**: http://localhost/inventory
- **Backend API**: http://localhost/api/
- **Backend Direct**: http://localhost:8080/api/

## Project Structure

```
project-root/
│
├── docker-compose.yml          # Main orchestration file
│
├── backend/
│   └── Dockerfile              # Backend Spring Boot container
│
├── inventoryui/
│   └── Dockerfile              # Inventory UI React container
│
├── websiteui/
│   └── Dockerfile              # Website UI React container
│
├── nginx/
│   └── default.conf            # NGINX reverse proxy configuration
│
└── .env                        # Environment variables (create this)
```

## Configuration

### NGINX Routing

- `/api/*` → Proxied to `backend:8080/api/*`
- `/inventory/*` → Proxied to `inventoryui:3001/*`
- `/` → Proxied to `websiteui:3000/*`

### Environment Variables

The `.env` file contains:
- MySQL credentials
- Database name
- Backend configuration (if needed)

**Important**: Never commit the `.env` file to version control. Add it to `.gitignore`.

## Development

### Rebuild a Specific Service

```bash
# Rebuild inventory UI
docker compose build --no-cache inventoryui
docker compose up -d inventoryui

# Rebuild backend
docker compose build --no-cache backend
docker compose up -d backend
```

### View Logs

```bash
# All services
docker compose logs -f

# Specific service
docker compose logs -f backend
docker compose logs -f inventoryui
docker compose logs -f nginx
```

### Stop Services

```bash
docker compose down
```

### Stop and Remove Volumes

```bash
docker compose down -v
```

**Warning**: This will delete all database data!

## Troubleshooting

### Services Not Starting

1. Check logs:
   ```bash
   docker compose logs
   ```

2. Verify `.env` file exists and has correct values

3. Check port availability:
   ```bash
   # Windows
   netstat -ano | findstr :80
   netstat -ano | findstr :8080
   
   # Linux/Mac
   lsof -i :80
   lsof -i :8080
   ```

### Database Connection Issues

1. Ensure MySQL container is healthy:
   ```bash
   docker compose ps mysql-db
   ```

2. Check MySQL logs:
   ```bash
   docker compose logs mysql-db
   ```

### API 404 Errors

- Verify backend is running: `docker compose ps backend`
- Check backend logs: `docker compose logs backend`
- Ensure NGINX is routing correctly: `docker compose logs nginx`

### Frontend Not Loading

1. Hard refresh browser: `Ctrl+F5` (Windows) or `Cmd+Shift+R` (Mac)
2. Check browser console for errors (F12)
3. Verify UI containers are running:
   ```bash
   docker compose ps inventoryui websiteui
   ```

## Deployment on DigitalOcean

### Automated Deployment (Recommended)

Use the provided deployment script for automated setup:

```bash
# Make script executable
chmod +x deploy.sh

# Run deployment script
./deploy.sh
```

The script will:
- ✅ Check and install Docker if needed
- ✅ Check and install Docker Compose if needed
- ✅ Verify repository exists
- ✅ Create `.env` file template if missing
- ✅ Build and start services (without stopping existing containers)
- ✅ Configure firewall
- ✅ Verify all services are running

**Note**: The script does NOT stop existing containers - it only builds and starts new/updated ones.

### Manual Step-by-Step Guide

If you prefer manual setup:

1. **Create Droplet**
   - Ubuntu 22.04
   - 2 GB RAM (minimum)
   - Enable Firewall

2. **Install Docker**
   ```bash
   curl -fsSL https://get.docker.com | sh
   sudo usermod -aG docker $USER
   ```

3. **Install Docker Compose**
   ```bash
   sudo apt update
   sudo apt install docker-compose-plugin -y
   ```

4. **Clone Repository**
   ```bash
   git clone <your-repo-url>
   cd katariastoneworldadmin
   ```

5. **Create `.env` File**
   ```bash
   nano .env
   # Add your environment variables
   ```

6. **Build and Start**
   ```bash
   docker compose up -d --build
   ```

7. **Configure Firewall**
   ```bash
   sudo ufw allow 80/tcp
   sudo ufw allow 443/tcp
   sudo ufw enable
   ```

8. **Verify Services**
   ```bash
   docker compose ps
   ```

### SSL/HTTPS Setup (Optional)

For production, configure SSL certificates:

1. Install Certbot:
   ```bash
   sudo apt install certbot python3-certbot-nginx -y
   ```

2. Update NGINX config to include SSL server block

3. Obtain certificate:
   ```bash
   sudo certbot --nginx -d yourdomain.com
   ```

## API Endpoints

The backend API is accessible at:

- Base URL: `http://localhost/api`
- Example: `http://localhost/api/auth/register`
- Example: `http://localhost/api/inventory`

All API requests should include the `/api` prefix when accessing through NGINX.

## Notes

- The Inventory UI is configured with `REACT_APP_API_URL=/api` during build
- All services communicate through Docker's internal network (`app-network`)
- Database data persists in Docker volume `mysql_data`
- NGINX handles CORS headers for API requests

## Support

For issues or questions, check:
1. Container logs: `docker compose logs`
2. Service status: `docker compose ps`
3. Network connectivity: `docker network inspect katariastoneworldadmin_app-network`
