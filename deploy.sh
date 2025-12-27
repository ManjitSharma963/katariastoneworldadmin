#!/bin/bash

# Kataria Stone World Admin - Deployment Script
# This script automates the deployment process on DigitalOcean or similar Ubuntu servers
# It does NOT stop existing containers - only builds and starts new ones

set -e  # Exit on error

echo "=========================================="
echo "Kataria Stone World Admin - Deployment"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${YELLOW}ℹ${NC} $1"
}

# Step 1: Check/Install Docker
echo "Step 1: Checking Docker installation..."
if command -v docker &> /dev/null; then
    print_success "Docker is already installed"
    docker --version
else
    print_info "Docker not found. Installing Docker..."
    curl -fsSL https://get.docker.com | sh
    sudo usermod -aG docker $USER
    print_success "Docker installed successfully"
    print_info "You may need to log out and log back in for Docker group changes to take effect"
fi

# Step 2: Check/Install Docker Compose
echo ""
echo "Step 2: Checking Docker Compose installation..."
if command -v docker compose version &> /dev/null || docker compose version &> /dev/null; then
    print_success "Docker Compose is already installed"
    docker compose version
else
    print_info "Docker Compose not found. Installing Docker Compose..."
    sudo apt update
    sudo apt install docker-compose-plugin -y
    print_success "Docker Compose installed successfully"
fi

# Step 3: Check if repository exists
echo ""
echo "Step 3: Checking repository..."
REPO_DIR="katariastoneworldadmin"
if [ -d "$REPO_DIR" ]; then
    print_success "Repository directory exists: $REPO_DIR"
    cd $REPO_DIR
    print_info "Pulling latest changes..."
    git pull || print_info "Not a git repository or unable to pull"
else
    print_info "Repository not found. Please clone it manually:"
    echo "  git clone <your-repo-url>"
    echo "  cd $REPO_DIR"
    read -p "Press Enter after cloning the repository, or Ctrl+C to exit..."
    if [ -d "$REPO_DIR" ]; then
        cd $REPO_DIR
    else
        print_error "Repository directory still not found. Exiting."
        exit 1
    fi
fi

# Step 4: Check/Create .env file
echo ""
echo "Step 4: Checking .env file..."
if [ -f ".env" ]; then
    print_success ".env file exists"
    print_info "Current .env file will be used"
else
    print_info ".env file not found. Creating template..."
    cat > .env << EOF
# MySQL Database Configuration
MYSQL_ROOT_PASSWORD=rootpassword123
MYSQL_DATABASE=katariastoneworld
MYSQL_USER=katariauser
MYSQL_PASSWORD=katariapass123

# Backend Configuration (add your Spring Boot config here if needed)
EOF
    print_success ".env file created with default values"
    print_info "Please edit .env file with your actual values before continuing"
    read -p "Press Enter to continue after editing .env (or Ctrl+C to exit)..."
fi

# Step 5: Build and Start Services (without stopping existing)
echo ""
echo "Step 5: Building and starting services..."
print_info "This will build/update containers without stopping existing ones"
docker compose up -d --build
print_success "Services built and started"

# Step 6: Configure Firewall
echo ""
echo "Step 6: Configuring firewall..."
if command -v ufw &> /dev/null; then
    print_info "Configuring UFW firewall..."
    sudo ufw allow 80/tcp || print_info "Port 80 already allowed"
    sudo ufw allow 443/tcp || print_info "Port 443 already allowed"
    
    # Check if UFW is active
    if sudo ufw status | grep -q "Status: active"; then
        print_success "UFW is already active"
    else
        print_info "Enabling UFW..."
        echo "y" | sudo ufw enable || print_info "UFW enable skipped or already enabled"
    fi
    print_success "Firewall configured"
else
    print_info "UFW not found. Skipping firewall configuration."
    print_info "Please configure your firewall manually to allow ports 80 and 443"
fi

# Step 7: Verify Services
echo ""
echo "Step 7: Verifying services..."
echo ""
docker compose ps
echo ""

# Check if all services are running
ALL_RUNNING=true
SERVICES=("mysql-db" "backend" "inventoryui" "websiteui" "nginx")

for service in "${SERVICES[@]}"; do
    if docker compose ps | grep -q "$service.*Up"; then
        print_success "$service is running"
    else
        print_error "$service is not running"
        ALL_RUNNING=false
    fi
done

echo ""
if [ "$ALL_RUNNING" = true ]; then
    print_success "All services are running!"
    echo ""
    echo "=========================================="
    echo "Deployment completed successfully!"
    echo "=========================================="
    echo ""
    echo "Access your application at:"
    echo "  - Website UI: http://$(hostname -I | awk '{print $1}')/"
    echo "  - Inventory UI: http://$(hostname -I | awk '{print $1}')/inventory"
    echo "  - Backend API: http://$(hostname -I | awk '{print $1}')/api/"
    echo ""
else
    print_error "Some services are not running. Check logs with:"
    echo "  docker compose logs"
    echo ""
    exit 1
fi

# Display helpful commands
echo "Useful commands:"
echo "  View logs:        docker compose logs -f"
echo "  Stop services:    docker compose down"
echo "  Restart service:  docker compose restart <service-name>"
echo ""

