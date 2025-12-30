# Authentication Setup Guide

## Overview
The Male Swiftie Sanctuary now has complete authentication and authorization with:
- User login/registration
- Admin dashboard for user management
- Protected routes (script.html requires login)
- Role-based access control (admin vs regular users)

## Setup Steps

### 1. Create the Users Table in Database

Run this SQL in your Neon dashboard:

```sql
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(50) UNIQUE NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  role VARCHAR(20) DEFAULT 'user' CHECK (role IN ('user', 'admin')),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
```

Or simply run the provided SQL file:
- File: `create-users-table.sql`

### 2. Install Dependencies

The following packages have been added:
- `bcrypt` - Password hashing
- `express-session` - Session management

Run:
```bash
npm install
```

### 3. Update Environment Variables

Add this to your `.env` file:
```
SESSION_SECRET=your-secret-key-change-this-in-production
```

Generate a random secret for production:
```bash
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

### 4. Create Admin Account

Run the seed script to create your admin account:
```bash
node seed-admin.js
```

Default credentials:
- Username: `jared`
- Password: `sanctuary2025`

⚠️ **IMPORTANT**: Change this password after first login!

### 5. Start the Server

```bash
npm start
```

## How It Works

### Authentication Flow

1. **Visiting script.html** → Redirected to login if not authenticated
2. **Login page** → Validates credentials, creates session
3. **Session check** → All protected pages verify authentication status
4. **Admin links** → Only visible to users with admin role

### New Files Created

#### Frontend:
- `public/login.html` - Login page
- `public/pages/register.html` - User registration page
- `public/pages/admin.html` - Admin dashboard (admin only)

#### Backend:
- `create-users-table.sql` - Database schema
- `seed-admin.js` - Create initial admin account

#### Updated Files:
- `server.js` - Added auth routes and middleware
- `public/script.html` - Added auth check and admin nav
- `public/index.html` - Added conditional admin nav link
- `public/pages/about.html` - Added conditional admin nav link
- `public/stories.html` - Added conditional admin nav link
- `public/style.css` - Added login/admin styling
- `package.json` - Added bcrypt and express-session

### API Endpoints

#### Authentication:
- `POST /api/login` - Login with username/password
- `POST /api/logout` - Destroy session
- `POST /api/register` - Create new user account
- `GET /api/auth/status` - Check authentication status

#### User Management (Admin Only):
- `GET /api/users` - List all users
- `DELETE /api/users/:id` - Delete a user

#### Members (Existing):
- `GET /api/members` - List all members
- `POST /api/members` - Add new member

### Admin Features

Admins can:
1. See "Admin" link in navbar on all pages
2. Access admin dashboard at `/pages/admin.html`
3. View all registered users
4. Delete non-admin users
5. See user roles and creation dates

### User Features

Regular users can:
1. Register for an account
2. Login to access script.html
3. Join as a member (add to members table)
4. View all member stories
5. Logout

### Security Features

✅ Password hashing with bcrypt (10 salt rounds)
✅ Session-based authentication
✅ HTTP-only cookies
✅ Role-based access control (RBAC)
✅ Protected routes with middleware
✅ Admin self-deletion prevention
✅ Duplicate username/email prevention

## Testing the Authentication

1. **Create admin account**: `node seed-admin.js`
2. **Start server**: `npm start`
3. **Try to access script.html**: Should redirect to login
4. **Login as admin**: Use `jared` / `sanctuary2025`
5. **Check admin link**: Should see "Admin" in navbar
6. **Visit admin dashboard**: Manage users
7. **Register new user**: Create a regular user account
8. **Delete user as admin**: Test user management

## Troubleshooting

### "Authentication required" error
- Make sure you're logged in
- Clear cookies and login again
- Check that server is running

### Admin link not showing
- Verify you're logged in as admin
- Check browser console for errors
- Verify session is working (check /api/auth/status)

### Can't login
- Verify users table exists in database
- Check that admin account was created
- Verify credentials are correct
- Check server logs for errors

### Session not persisting
- Make sure SESSION_SECRET is set in .env
- Check that cookies are enabled in browser
- Verify CORS settings allow credentials

## Production Considerations

Before deploying:
1. ✅ Change SESSION_SECRET to random value
2. ✅ Set cookie.secure to `true` if using HTTPS
3. ✅ Change admin password from default
4. ✅ Update CORS origin to your domain
5. ✅ Consider adding rate limiting on login endpoint
6. ✅ Enable HTTPS for production
7. ✅ Use environment-specific session store (Redis, etc.)

## Next Steps (Optional Enhancements)

- [ ] Password reset functionality
- [ ] Email verification
- [ ] Two-factor authentication
- [ ] Remember me functionality
- [ ] Password strength requirements
- [ ] Account lockout after failed attempts
- [ ] Session expiration warnings
- [ ] Admin ability to change user roles
- [ ] Audit log of admin actions
