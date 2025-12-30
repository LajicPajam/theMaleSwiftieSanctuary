# Deploying to Your Server - Super Simple Guide 🚀

## What You're Building
- **Container 1**: Your website (Node.js app)
- **Container 2**: Your database (PostgreSQL)
- Both talk to each other in their own private network
- Data is saved in a special folder that survives restarts

---

## Step 1: Get Your Code on the Server

**On your server:**

```bash
# Go to where you want your website
cd /home/yourname

# Download your code from GitHub
git clone https://github.com/LajicPajam/theMaleSwiftieSanctuary.git

# Go into the folder
cd theMaleSwiftieSanctuary
```

---

## Step 2: Set Up Your Secrets

**Create your environment file:**

```bash
# Copy the example file
cp .env.docker .env

# Edit it with your favorite editor (nano is easiest)
nano .env
```

**Inside .env, change these:**

```env
DB_USER=swiftie
DB_PASSWORD=PICK_A_STRONG_PASSWORD_HERE
DB_NAME=SwiftieSanctuary
SESSION_SECRET=PICK_A_RANDOM_LONG_STRING_HERE
```

💡 **Tip**: For `SESSION_SECRET`, mash your keyboard randomly for like 30 characters!

**Save and exit:** Press `Ctrl+X`, then `Y`, then `Enter`

---

## Step 3: Start Everything Up

**One simple command does it all:**

```bash
docker-compose up -d
```

**What just happened?**
- Docker downloaded PostgreSQL (the database software)
- Docker built your website into a container
- Both started running together
- `-d` means "run in background"

**Check if they're running:**

```bash
docker-compose ps
```

You should see 2 containers running! ✅

---

## Step 4: Set Up Your Database Tables

**Your database is empty! Let's add the tables:**

```bash
# This runs the SQL commands to create tables
docker exec -i themaleswiftiesanctuary-db-1 psql -U swiftie -d SwiftieSanctuary < init.sql
```

**What did that do?**
- Created the `users` table (for accounts)
- Created the `members` table (for stories)
- Created an admin account
  - Username: `admin`
  - Password: `admin123` ⚠️ **CHANGE THIS IMMEDIATELY!**

---

## Step 5: Access Your Website

**Your site is now live at:**
```
http://YOUR_SERVER_IP:3000
```

For example: `http://192.168.1.100:3000`

---

## Step 6: Set Up a Real Domain (Optional but Recommended)

Right now people have to type `:3000` which is ugly. Let's fix that with nginx!

**Install nginx:**
```bash
sudo apt install nginx
```

**Create a config file:**
```bash
sudo nano /etc/nginx/sites-available/swiftie
```

**Paste this in:**
```nginx
server {
    listen 80;
    server_name yourwebsite.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

**Enable it:**
```bash
sudo ln -s /etc/nginx/sites-available/swiftie /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

**Now your site works at:** `http://yourwebsite.com` (no :3000!)

---

## Daily Operations Cheat Sheet

### View Logs (See What's Happening)
```bash
docker-compose logs -f app    # Website logs
docker-compose logs -f db     # Database logs
```
Press `Ctrl+C` to stop watching

### Stop Everything
```bash
docker-compose down
```

### Start Everything Again
```bash
docker-compose up -d
```

### Restart After Code Changes
```bash
git pull                        # Get new code
docker-compose up -d --build   # Rebuild and restart
```

### Backup Your Database (DO THIS WEEKLY!)
```bash
docker exec themaleswiftiesanctuary-db-1 pg_dump -U swiftie SwiftieSanctuary > backup-$(date +%Y%m%d).sql
```

### Restore from Backup
```bash
docker exec -i themaleswiftiesanctuary-db-1 psql -U swiftie SwiftieSanctuary < backup-20250101.sql
```

---

## Troubleshooting

### "Can't connect to database!"
```bash
# Check if database is running
docker-compose ps

# See database logs
docker-compose logs db
```

### "Website won't start!"
```bash
# See what went wrong
docker-compose logs app

# Rebuild from scratch
docker-compose down
docker-compose up -d --build
```

### "I locked myself out!"
Reset admin password by connecting to database:
```bash
docker exec -it themaleswiftiesanctuary-db-1 psql -U swiftie SwiftieSanctuary
```

Then run:
```sql
UPDATE users SET password_hash = '$2b$10$rVZLd8WzY3FnXqxHFkxJKuEYx8Z9K5m3YtX9pW7qQ0xH8vR1LnN2C' WHERE username = 'admin';
\q
```
Now admin password is `admin123` again.

---

## What If Your Server Restarts?

**Don't worry!** Docker is set to `restart: unless-stopped`

This means:
- When your server boots up, Docker automatically starts
- Docker automatically starts your containers
- Your website comes back online by itself! 🎉

Your data is safe in the `postgres-data` volume.

---

## Security Checklist Before Going Live

- [ ] Changed `DB_PASSWORD` to something strong
- [ ] Changed `SESSION_SECRET` to something random
- [ ] Changed admin password from `admin123`
- [ ] Set up nginx with a real domain
- [ ] Set up SSL/HTTPS (use `certbot` - it's free!)
- [ ] Set up automatic database backups (cron job)
- [ ] Only open ports 80 and 443 in firewall

---

## That's It! 🎊

Your website is now running with:
- ✅ App in a container
- ✅ Database in a container  
- ✅ Data that persists
- ✅ Automatic restarts
- ✅ Easy updates with `git pull` + rebuild

Questions? Check the logs with `docker-compose logs -f`
