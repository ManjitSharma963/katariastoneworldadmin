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
