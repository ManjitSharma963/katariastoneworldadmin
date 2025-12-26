Internet
   │
   ▼
┌──────────────┐
│   NGINX      │  (Reverse Proxy, SSL)
│  :80 / :443  │
└──────┬───────┘
       │
 ┌─────┼───────────────┐
 │     │               │
 ▼     ▼               ▼
UI-1  UI-2          Backend
:3000 :3000          :8080
                       │
                       ▼
                     MySQL
                     :3306
					 
					 
					 
					 
					 
					 
DEPLOY ON DIGITALOCEAN (STEP-BY-STEP)
🔹 Create Droplet
   Ubuntu 22.04
   2 GB RAM (minimum)
   Enable Firewall
   
🔹 Install Docker
   curl -fsSL https://get.docker.com | sh

🔹 Install Docker Compose
   sudo apt install docker-compose -y

🔹 Clone Repo
   git clone your-repo.git
   cd your-repo

🔹 Run
   docker compose up -d --build








project-root/
│
├── docker-compose.yml
│
├── backend/
│   └── Dockerfile
│
├── websiteui/
│   ├── Dockerfile
│   └── nginx.conf
│
├── inventoryui/
│   ├── Dockerfile
│   └── nginx.conf
│
├── nginx/
│   └── default.conf
│
└── .env

