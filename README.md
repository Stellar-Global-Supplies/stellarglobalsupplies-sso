# Casdoor SSO — Koyeb + NeonDB

Central SSO / frontdoor for Stellar Global Supplies apps.  
Stack: **Casdoor** (IdP) · **NeonDB** (PostgreSQL, free) · **Koyeb** (Docker hosting, free)

---

## 🔐 Security Model — No Secrets in This Repo

```
app.conf  →  only ${PLACEHOLDERS}   ✅ safe to commit
.env      →  real secrets           🚫 gitignored, local only
Koyeb     →  real secrets           ✅ set in dashboard, encrypted
```

**Real values are NEVER in the code.**  
`entrypoint.sh` injects them from env vars at container startup.

---

## File Structure

```
casdoor-koyeb/
├── Dockerfile         # Extends casbin/casdoor:latest
├── entrypoint.sh      # Injects env vars into app.conf at startup
├── app.conf           # Casdoor config — placeholders only, safe to commit
├── docker-compose.yml # Local dev only (reads from .env)
├── .env.example       # Template — copy to .env for local dev
├── .gitignore         # Ensures .env is never committed
└── README.md          # This file
```

---

## Phase 1 — Setup (this repo)

### Step 1 — NeonDB (Free Database, No CC)

1. Go to **https://neon.tech** → sign up with GitHub
2. Create a project → name it `casdoor`
3. Go to **Connection Details** → copy the connection string
4. **Convert** from URL format to space-separated DSN:

   URL format (what Neon gives you):
   ```
   postgresql://neondb_owner:PASSWORD@ep-xxx.neon.tech/neondb?sslmode=require
   ```
   Space-separated format (what Casdoor needs):
   ```
   user=neondb_owner password=PASSWORD host=ep-xxx.neon.tech port=5432 dbname=neondb sslmode=require
   ```

### Step 2 — Push this repo to GitHub

```bash
git init
git add .
git commit -m "feat: casdoor sso setup"
git remote add origin https://github.com/YOUR-ORG/stellar-sso.git
git push -u origin main
```

> ✅ Safe to push — `app.conf` has only placeholders, `.env` is gitignored

### Step 3 — Deploy on Koyeb (Free, No CC)

1. Go to **https://koyeb.com** → sign up with GitHub
2. Click **Create App** → choose **GitHub** as source
3. Select your repo → branch `main`
4. Koyeb detects the `Dockerfile` automatically
5. Set **Port** to `8000`
6. Go to **Environment Variables** tab → add:

   | Key | Value |
   |-----|-------|
   | `DB_CONNECTION_STRING` | `user= password= host=ep-damp-hall-b3tuk8f4-pooler.c-4.ap-southeast-1.aws.neon.tech port=5432 dbname=neondb sslmode=require` |
   | `CASDOOR_ORIGIN` | `https://your-app.koyeb.app` ← update after step 7 |

7. Click **Deploy** → wait ~2 mins
8. Koyeb gives you a domain like `stellar-sso-xxxx.koyeb.app`
9. **Update** `CASDOOR_ORIGIN` env var with your actual Koyeb domain → redeploy

### Step 4 — First Login

1. Open your Koyeb domain in browser
2. Login:
   ```
   Username: admin
   Password: 123
   ```
3. **Immediately** go to top-right → Profile → change password

### Step 5 — Create Organization

1. Go to **Organizations** → **Add**
2. Name: `stellar-global`
3. Display name: `Stellar Global Supplies`
4. Save

### Step 6 — Register Your Apps

For each of your 7-8 apps:

1. Go to **Applications** → **Add**
2. Fill in:
   ```
   Name:          prowler-security
   Organization:  stellar-global
   Homepage:      https://your-app-url.com
   Redirect URL:  https://your-app-url.com/callback
   Grant type:    Authorization Code
   ```
3. Save → copy **Client ID** and **Client Secret** (needed for P2)

### Step 7 — Keep Alive (Free Tier Sleeps After 1 hr)

1. Go to **https://uptimerobot.com** → free account
2. Add monitor → HTTP(s) → URL: `https://your-app.koyeb.app/api/health`
3. Interval: **5 minutes**

---

## Local Development

```bash
# 1. Clone repo
git clone https://github.com/YOUR-ORG/stellar-sso.git
cd stellar-sso

# 2. Create .env from example
cp .env.example .env
# Edit .env — fill in your NeonDB connection string

# 3. Run
docker compose up --build

# 4. Open
open http://localhost:8000
# Login: admin / 123
```

---

## Environment Variables Reference

| Variable | Where to set | Description |
|---|---|---|
| `DB_CONNECTION_STRING` | Koyeb dashboard → Variables | NeonDB DSN (space-separated format) |
| `CASDOOR_ORIGIN` | Koyeb dashboard → Variables | Your public Koyeb domain, no trailing slash |

**Never put real values in `app.conf` or commit a filled `.env` file.**

---

## Phases

| Phase | What | Status |
|---|---|---|
| **P1** | Casdoor + NeonDB on Koyeb | 📍 This repo |
| **P2** | Migrate 7-8 React SPAs one by one | Next |
| **P3** | Custom JWT validation in CF Workers | Later |