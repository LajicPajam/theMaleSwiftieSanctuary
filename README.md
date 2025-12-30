# The Male Swiftie Sanctuary 🎤💔

A safe space for male Swifties to connect and share their love for Taylor Swift.

## 📁 Project Structure

```
theMaleSwiftieSanctuary/
├── public/               # Frontend files (HTML, CSS, JS)
│   ├── index.html       # Homepage
│   ├── script.html      # Member signup page
│   ├── style.css        # Styles
│   ├── extra.js         # Frontend JavaScript
│   └── pages/           # Additional pages
├── server.js            # Express backend server
├── setup-database.sql   # Database schema
├── .env                 # Environment variables (DO NOT COMMIT)
├── .env.example         # Template for environment variables
└── package.json         # Dependencies

```

## 🚀 Local Development Setup

### Prerequisites
- Node.js (v14+)
- PostgreSQL

### Installation

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd theMaleSwiftieSanctuary
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Set up PostgreSQL database**
   ```sql
   CREATE DATABASE swiftie_sanctuary;
   ```
   Then run the SQL from `setup-database.sql`:
   ```bash
   psql -U postgres -d swiftie_sanctuary -f setup-database.sql
   ```

4. **Configure environment variables**
   - Copy `.env.example` to `.env`
   - Update with your database credentials:
   ```
   DB_USER=your_postgres_username
   DB_PASSWORD=your_postgres_password
   DB_NAME=swiftie_sanctuary
   ```

5. **Start the server**
   ```bash
   npm start
   ```

6. **Open in browser**
   ```
   http://localhost:3000
   ```

## 🌐 Deployment

### Environment Variables
Make sure to set these on your hosting platform:
- `DB_USER` - PostgreSQL username
- `DB_HOST` - Database host (e.g., your cloud DB URL)
- `DB_NAME` - Database name
- `DB_PASSWORD` - Database password
- `DB_PORT` - Database port (default: 5432)
- `PORT` - Server port (default: 3000)
- `NODE_ENV` - Set to `production`

### Recommended Platforms
- **Hosting**: Render, Railway, Heroku, or Vercel
- **Database**: Supabase (PostgreSQL), Railway, or Neon

### Deployment Example (Render)
1. Push code to GitHub
2. Create new Web Service on Render
3. Connect your GitHub repo
4. Add environment variables from `.env`
5. Deploy!

## 📝 License
All Feelings Reserved © 2025
