-- Remove email column from members table since it's available via user_id -> users table JOIN
ALTER TABLE members DROP COLUMN IF EXISTS email;
