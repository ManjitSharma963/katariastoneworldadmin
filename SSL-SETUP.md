# SSL/HTTPS Setup for www.katariastoneworld.com

This guide enables HTTPS so that:

- **Website:** `https://www.katariastoneworld.com/`
- **Inventory app:** `https://www.katariastoneworld.com/inventory`

HTTP requests are redirected to HTTPS.

**Database safety:** This setup **does not update, restart, or delete** the database or the MySQL container. Only nginx config and the nginx container are changed; MySQL, backend, and data volumes are left unchanged.

## Prerequisites

- Domain **www.katariastoneworld.com** (and optionally **katariastoneworld.com**) must point to your server’s public IP (A records).
- Ports **80** and **443** open on the server (e.g. `ufw allow 80/tcp && ufw allow 443/tcp`).

## Step 1: Stack running (no database change)

- **If the stack is already running:** Do nothing here. Go to Step 2. Your database and other services are not touched.
- **If you are starting from scratch:** Start only what you need. The default nginx config works without certificates. Do **not** use `docker compose down -v` (the `-v` flag removes volumes and would delete the database).

```bash
docker compose up -d --build
```

Ensure the site is reachable on HTTP (e.g. `http://www.katariastoneworld.com`).

## Step 2: Obtain Let’s Encrypt certificate

Run certbot once (with your email):

```bash
docker compose run --rm certbot certonly \
  --webroot \
  -w /var/www/certbot \
  -d www.katariastoneworld.com \
  -d katariastoneworld.com \
  --email your@email.com \
  --agree-tos \
  --no-eff-email
```

Certificates are stored in the `certbot_conf` volume shared with nginx.

## Step 3: Switch nginx to HTTPS

Use the SSL config and restart **only nginx** (database and other services are not restarted):

**Linux/macOS:**

```bash
cp nginx/default-ssl.conf nginx/default.conf
docker compose restart nginx
```

**Windows (PowerShell):**

```powershell
Copy-Item nginx\default-ssl.conf nginx\default.conf
docker compose restart nginx
```

## Step 4: Verify

- `https://www.katariastoneworld.com/` → website  
- `https://www.katariastoneworld.com/inventory` → inventory app  
- `http://www.katariastoneworld.com/` → redirects to HTTPS  

## Renewing certificates

Let’s Encrypt certs expire after 90 days. Renew with (only nginx is restarted; database is not touched):

```bash
docker compose run --rm certbot renew
docker compose restart nginx
```

You can run this manually or via a cron job (e.g. every 2 months).

## Using your own certificates

If you use another CA (not Let’s Encrypt):

1. Put your full chain and private key where nginx can read them (e.g. copy into the `certbot_conf` volume or mount your own volume).
2. In `nginx/default-ssl.conf`, set:
   - `ssl_certificate` to your full chain path (e.g. `fullchain.pem`).
   - `ssl_certificate_key` to your private key path (e.g. `privkey.pem`).
3. Copy `default-ssl.conf` to `default.conf` and restart nginx as in Step 3.

## Troubleshooting

- **Nginx won’t start after switching to SSL**  
  Confirm certs exist:  
  `docker compose run --rm certbot certificates`  
  If empty, run Step 2 again.

- **“Connection refused” on HTTPS**  
  Ensure port 443 is open and that `docker compose` exposes `443:443` for the nginx service.

- **Certificate errors in browser**  
  Ensure the domain in the cert matches the URL and that you’re using `default-ssl.conf` (not the HTTP-only default).
