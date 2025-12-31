-- Migration script to set up database schema
-- Run this when starting with a fresh PostgreSQL database

-- Create session table for connect-pg-simple
CREATE TABLE IF NOT EXISTS "session" (
  "sid" varchar NOT NULL COLLATE "default",
  "sess" json NOT NULL,
  "expire" timestamp(6) NOT NULL,
  CONSTRAINT "session_pkey" PRIMARY KEY ("sid")
);
CREATE INDEX IF NOT EXISTS "IDX_session_expire" ON "session" ("expire");

-- Create users table
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(255) UNIQUE NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  role VARCHAR(50) DEFAULT 'user',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create members table
CREATE TABLE IF NOT EXISTS members (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  favorite_song VARCHAR(500) NOT NULL,
  story TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_members_user_id ON members(user_id);
CREATE UNIQUE INDEX IF NOT EXISTS idx_members_user_id_unique ON members(user_id) WHERE user_id IS NOT NULL;

-- Create an admin user (password is 'admin123' - CHANGE THIS!)
-- Password hash for 'admin123' with bcrypt salt rounds 10
INSERT INTO users (username, email, password_hash, role) 
VALUES (
  'admin',
  'admin@swiftiesanctuary.com',
  '$2b$10$rVZLd8WzY3FnXqxHFkxJKuEYx8Z9K5m3YtX9pW7qQ0xH8vR1LnN2C',
  'admin'
) ON CONFLICT (email) DO NOTHING;
