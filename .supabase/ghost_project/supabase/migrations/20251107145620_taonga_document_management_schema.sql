SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_schema = 'tiwhanawhana'
ORDER BY table_name;

PGPASSWORD="<YOUR_DB_PASSWORD>" \
pg_dump \
  -h aws-1-ap-southeast-2.pooler.supabase.com \
  -U postgres.ruqejtkudezadrqbdodx \
  -d postgres \
  -n kitenga -n public -n rongohia \
  --no-owner --no-privileges \
  --encoding=UTF8 --format=plain \
  > ~/Desktop/ghost_trace_backup.sql
-- WARNING: This schema is for context only and not meant to be executed directly.
-- Table order and constraints may not be valid for one-pass execution.

sql output_content
-- Generated for Tiwhanawhana Orchestrator – the living Awa of Translation, Vision, and Memory.
CREATE SCHEMA IF NOT EXISTS tiwhanawhana;
SET search_path TO tiwhanawhana;
-- ==========================================================
-- 🔮 MAURI LOGS — tracks every awakening, breath, and sync
-- ==========================================================
CREATE TABLE IF NOT EXISTS tiwhanawhana.mauri_logs (
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
ALTER TABLE tiwhanawhana.mauri_logs ENABLE ROW LEVEL SECURITY;
-- 🔑 Allow the Supabase service role to insert
CREATE POLICY service_role_insert
  ON tiwhanawhana.mauri_logs
  FOR INSERT
  WITH CHECK (auth.role() = 'service_role');
  #who is the service role?
-- 🔑 Allow the Supabase service role to read
CREATE POLICY service_role_read
  ON tiwhanawhana.mauri_logs
  FOR SELECT
  WITH CHECK (auth.role() = 'service_role');