# Server setup steps (run on your production server)

Follow these steps in order on the server (e.g. `root@prod-docker-server`).

---

## 1. Go to the project directory

```bash
cd ~/katariastoneworldadmin
```

---

## 2. Pull latest code (if you use git)

```bash
git pull
```

---

## 3. Start with HTTP only (so nginx starts without certs)

```bash
cp nginx-http-only.conf nginx.conf
docker compose up -d --no-recreate
```

If nginx was already running:

```bash
docker compose restart nginx
```

Check that the site works on **HTTP**: open `http://www.katariastoneworld.com` in a browser.

---

## 4. Get SSL certificates (Let's Encrypt)

Install certbot if needed:

```bash
sudo apt update
sudo apt install -y certbot
```

**Option A – Standalone (easiest, nginx must be stopped briefly)**

```bash
docker compose stop nginx
sudo certbot certonly --standalone -d www.katariastoneworld.com -d katariastoneworld.com --email your@email.com --agree-tos --no-eff-email
docker compose start nginx
```

Replace `your@email.com` with your real email.

**Option B – Webroot (nginx keeps running)**

If you have a folder on the server that nginx serves at `/.well-known/acme-challenge/`, use that path as `-w`. Otherwise use Option A.

```bash
sudo certbot certonly --webroot -w /var/www/html -d www.katariastoneworld.com -d katariastoneworld.com --email your@email.com --agree-tos --no-eff-email
```

---

## 5. Check that certs exist

```bash
sudo ls -la /etc/letsencrypt/live/www.katariastoneworld.com/
```

You should see `fullchain.pem` and `privkey.pem`.

---

## 6. Switch to HTTPS config and restart nginx

```bash
cp nginx-ssl.conf nginx.conf
docker compose restart nginx
```

Or, if your main `nginx.conf` in the repo is already the HTTPS one:

```bash
git checkout nginx.conf
docker compose restart nginx
```

---

## 7. Verify HTTPS

- Open: **https://www.katariastoneworld.com/**
- Open: **https://www.katariastoneworld.com/inventory**
- Open: **http://www.katariastoneworld.com/** — it should redirect to HTTPS.

---

## HTTP works but HTTPS does not

Do these on the server in order.

**Step 1 – Certificates must exist**

```bash
sudo ls -la /etc/letsencrypt/live/www.katariastoneworld.com/
```

You must see `fullchain.pem` and `privkey.pem`. If not, get certs first (see Step 4 in this file: stop nginx, run certbot, start nginx).

**Step 2 – Switch nginx to HTTPS config**

```bash
cd ~/katariastoneworldadmin
cp nginx-ssl.conf nginx.conf
```

**Step 3 – Restart nginx**

```bash
docker compose restart nginx
```

Check nginx is running and not crashing:

```bash
docker ps
docker compose logs nginx --tail 20
```

If you see "cannot load certificate" or nginx keeps restarting, certs are missing or wrong path — go back to Step 1.

**Step 4 – Open port 443 in firewall**

```bash
sudo ufw allow 443/tcp
sudo ufw status
sudo ufw reload
```

**Step 5 – Test HTTPS from the server**

```bash
curl -k -I https://localhost/
```

You should get `HTTP/2 200` (or 301/302). Then try in the browser: **https://www.katariastoneworld.com/**

---

## 8. (Optional) Renew certs later

Let's Encrypt certs last 90 days. To renew:

```bash
sudo certbot renew
docker compose restart nginx
```

You can add a cron job to run `certbot renew` every month.

---

## Quick reference

| Step | Command |
|------|--------|
| Use HTTP-only config | `cp nginx-http-only.conf nginx.conf && docker compose restart nginx` |
| Get certs (standalone) | `docker compose stop nginx` then `sudo certbot certonly --standalone -d www.katariastoneworld.com -d katariastoneworld.com --email your@email.com --agree-tos --no-eff-email` then `docker compose start nginx` |
| Switch to HTTPS | `cp nginx-ssl.conf nginx.conf && docker compose restart nginx` |
| Restart only nginx | `docker compose restart nginx` |

**Important:** Do **not** run `docker compose down -v` — the `-v` flag deletes volumes and would remove your database.

---

## Troubleshooting: ERR_CONNECTION_REFUSED (site can’t be reached)

If the browser says “refused to connect” or “This site can’t be reached”:

**1. Ensure nginx and app containers are running**
```bash
cd ~/katariastoneworldadmin
docker ps
```
You must see `nginx`, `websiteui`, `inventoryui`, `backend` with status **Up**. If any are missing:
```bash
docker compose up -d
```

**2. If nginx keeps exiting (e.g. no SSL certs yet)**  
Use HTTP-only config so nginx can start, then open the site on **http** first:
```bash
cp nginx-http-only.conf nginx.conf
docker compose up -d nginx
docker ps   # nginx should be Up
```
Then open **http://www.katariastoneworld.com** (not https). After you have certs, switch to the HTTPS config.

**3. Open firewall ports 80 and 443**
```bash
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw status
sudo ufw enable   # if not already enabled
```

**4. Confirm something is listening on 80 and 443**
```bash
sudo ss -tlnp | grep -E ':80|:443'
# or
sudo netstat -tlnp | grep -E ':80|:443'
```
You should see Docker or nginx listening on 0.0.0.0:80 and 0.0.0.0:443.

**5. Test from the server**
```bash
curl -I http://localhost/
curl -k -I https://localhost/
```
If these work but the browser still gets “refused”, the firewall or cloud security group is blocking external access to 80/443.

**6. Cloud server (AWS, DigitalOcean, etc.)**  
In the provider’s dashboard, open **inbound** ports **80** and **443** (TCP) for the server’s IP or security group.

---

## Troubleshooting: Nothing shows on https://www.katariastoneworld.com/

Run these on the server and fix what fails.

**1. All containers running**
```bash
docker ps
```
Ensure `nginx`, `websiteui`, `inventoryui`, `backend` are **Up**. If `websiteui` is exited, run:
```bash
docker compose up -d websiteui
```

**2. Nginx can reach websiteui**
```bash
docker compose exec nginx wget -q -O - http://websiteui:3000/ | head -20
```
You should see HTML (e.g. `<!DOCTYPE html>`). If it hangs or "bad gateway", the app container or network is the problem.

**3. Nginx error log**
```bash
docker compose logs nginx --tail 50
```
Look for `upstream timed out`, `502`, or `connection refused`. Fix the upstream (websiteui) if needed.

**4. Test HTTPS from the server**
```bash
curl -k -I https://localhost/
```
You should get `HTTP/2 200` (or 301/302). If you get 502, nginx can’t reach websiteui.

**5. Browser: check what’s actually loaded**
- Open https://www.katariastoneworld.com/
- Press **F12** → **Network** tab → refresh. See if the first request (the page) is **200** or **502**.
- Open **Console** tab. Look for red errors (e.g. mixed content, blocked scripts).

**6. Mixed content (blank page but no 502)**  
If the page request is 200 but the screen is blank, the HTML may load but JS/CSS are blocked (e.g. requested over `http://` on an HTTPS page). Ensure the website app is built to use relative URLs or `https` for assets and API.
