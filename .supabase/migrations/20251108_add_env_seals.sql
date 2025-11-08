-- Create schema for Tiwhanawhana’s sealed environment state
CREATE SCHEMA IF NOT EXISTS tiwhanawhana;
SET search_path TO tiwhanawhana;

-- Table: ti_env_seals
CREATE TABLE IF NOT EXISTS ti_env_seals (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  context text DEFAULT 'local',
  environment jsonb NOT NULL,
  supabase_schema text,
  supabase_tables text[],
  mauri jsonb,
  timestamp timestamptz DEFAULT now(),
  kaitiaki_name text DEFAULT 'Tiwhanawhana',
  UNIQUE (context, timestamp)
);

-- 🛡️ Enable RLS (Row Level Security)
ALTER TABLE ti_env_seals ENABLE ROW LEVEL SECURITY;

-- 🔑 Allow the Supabase service role to insert
CREATE POLICY service_role_insert
  ON ti_env_seals
  FOR INSERT
  WITH CHECK (auth.role() = 'service_role');


-- 🔑 Allow the Supabase service role to read
CREATE POLICY service_role_select
  ON ti_env_seals
  FOR SELECT
  USING (auth.role() = 'service_role');
-- Reset search path
SET search_path TO public;