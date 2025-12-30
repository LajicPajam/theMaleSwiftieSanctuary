-- Add user_id column to members table (nullable to support existing members without accounts)
-- For new members: user_id will be populated from authenticated user
-- For old members: user_id remains NULL and they use first/last name

ALTER TABLE members ADD COLUMN user_id INTEGER REFERENCES users(id) ON DELETE SET NULL;

-- Add partial unique constraint (only for non-null user_id values)
-- This ensures each user account can only have ONE story
CREATE UNIQUE INDEX idx_members_user_id_unique ON members(user_id) WHERE user_id IS NOT NULL;

-- Add index for faster lookups
CREATE INDEX idx_members_user_id ON members(user_id);
