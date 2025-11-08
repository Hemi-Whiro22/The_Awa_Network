-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.carver_context_memory (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid,
  context_type text NOT NULL,
  context_name text NOT NULL,
  context_description text,
  related_topics ARRAY,
  cultural_elements ARRAY,
  embedding USER-DEFINED,
  last_accessed timestamp with time zone DEFAULT now(),
  access_count integer DEFAULT 0,
  metadata jsonb,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT carver_context_memory_pkey PRIMARY KEY (id)
);
CREATE TABLE public.chat_messages (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  session_id text NOT NULL,
  message_type text NOT NULL CHECK (message_type = ANY (ARRAY['user'::text, 'kaitiaki'::text])),
  content text NOT NULL,
  kaitiaki_agent text,
  cultural_flags jsonb DEFAULT '{}'::jsonb,
  processing_time_ms integer,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT chat_messages_pkey PRIMARY KEY (id),
  CONSTRAINT chat_messages_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.chat_sessions(session_id)
);
CREATE TABLE public.chat_sessions (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  session_id text NOT NULL UNIQUE,
  user_identifier text,
  total_messages integer DEFAULT 0,
  created_at timestamp with time zone DEFAULT now(),
  last_activity timestamp with time zone DEFAULT now(),
  CONSTRAINT chat_sessions_pkey PRIMARY KEY (id)
);
CREATE TABLE public.cultural_permissions (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  resource_type text NOT NULL,
  resource_id uuid NOT NULL,
  permission_type text NOT NULL CHECK (permission_type = ANY (ARRAY['view'::text, 'process'::text, 'share'::text, 'modify'::text])),
  iwi_restriction text,
  tapu_level_required integer DEFAULT 0,
  elder_approval_required boolean DEFAULT false,
  cultural_context text,
  granted_by text,
  granted_at timestamp with time zone DEFAULT now(),
  expires_at timestamp with time zone,
  CONSTRAINT cultural_permissions_pkey PRIMARY KEY (id)
);
CREATE TABLE public.document_entities (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  document_id uuid NOT NULL,
  entity_text text NOT NULL,
  entity_type text NOT NULL,
  start_pos integer,
  end_pos integer,
  confidence_score numeric CHECK (confidence_score >= 0::numeric AND confidence_score <= 1::numeric),
  cultural_significance text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT document_entities_pkey PRIMARY KEY (id),
  CONSTRAINT document_entities_document_id_fkey FOREIGN KEY (document_id) REFERENCES public.documents(id)
);
CREATE TABLE public.document_relationships (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  source_document_id uuid NOT NULL,
  target_document_id uuid NOT NULL,
  relationship_type text NOT NULL CHECK (relationship_type = ANY (ARRAY['references'::text, 'similar_to'::text, 'part_of'::text, 'translation_of'::text, 'version_of'::text])),
  confidence_score numeric CHECK (confidence_score >= 0::numeric AND confidence_score <= 1::numeric),
  created_by text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT document_relationships_pkey PRIMARY KEY (id),
  CONSTRAINT document_relationships_source_document_id_fkey FOREIGN KEY (source_document_id) REFERENCES public.documents(id),
  CONSTRAINT document_relationships_target_document_id_fkey FOREIGN KEY (target_document_id) REFERENCES public.documents(id)
);
CREATE TABLE public.document_tags (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  document_id uuid NOT NULL,
  tag_name text NOT NULL,
  tag_value text,
  tag_type text DEFAULT 'general'::text CHECK (tag_type = ANY (ARRAY['general'::text, 'cultural'::text, 'technical'::text, 'administrative'::text])),
  confidence_score numeric CHECK (confidence_score >= 0::numeric AND confidence_score <= 1::numeric),
  created_by text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT document_tags_pkey PRIMARY KEY (id),
  CONSTRAINT document_tags_document_id_fkey FOREIGN KEY (document_id) REFERENCES public.documents(id)
);
CREATE TABLE public.documents (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  filename text NOT NULL,
  original_filename text NOT NULL,
  file_size bigint NOT NULL,
  content_type text NOT NULL,
  file_hash text NOT NULL UNIQUE,
  storage_path text,
  text_content text,
  summary text,
  summary_te_reo text,
  language_detected text DEFAULT 'en'::text,
  character_count integer DEFAULT 0,
  processing_status text DEFAULT 'uploaded'::text CHECK (processing_status = ANY (ARRAY['uploaded'::text, 'processing'::text, 'completed'::text, 'failed'::text])),
  processed_by text,
  processing_time_seconds numeric,
  extraction_method text,
  cultural_themes ARRAY DEFAULT '{}'::text[],
  tapu_level integer DEFAULT 0 CHECK (tapu_level >= 0 AND tapu_level <= 5),
  requires_elder_review boolean DEFAULT false,
  whakapapa_content boolean DEFAULT false,
  sacred_knowledge boolean DEFAULT false,
  iwi_affiliations ARRAY DEFAULT '{}'::text[],
  content_embedding USER-DEFINED,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  processed_at timestamp with time zone,
  CONSTRAINT documents_pkey PRIMARY KEY (id)
);
CREATE TABLE public.kaitiaki_context_memory (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  kaitiaki_name text NOT NULL,
  user_id uuid,
  context_type text NOT NULL,
  context_name text NOT NULL,
  context_description text,
  related_topics ARRAY,
  cultural_elements ARRAY,
  embedding USER-DEFINED,
  last_accessed timestamp with time zone DEFAULT now(),
  access_count integer DEFAULT 0,
  metadata jsonb,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT kaitiaki_context_memory_pkey PRIMARY KEY (id)
);
CREATE TABLE public.kitenga_context_memory (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid,
  context_type text NOT NULL,
  context_name text NOT NULL,
  context_description text,
  related_topics ARRAY,
  cultural_elements ARRAY,
  embedding USER-DEFINED,
  last_accessed timestamp with time zone DEFAULT now(),
  access_count integer DEFAULT 0,
  metadata jsonb,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT kitenga_context_memory_pkey PRIMARY KEY (id)
);
CREATE TABLE public.koru_context_memory (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid,
  context_type text NOT NULL,
  context_name text NOT NULL,
  context_description text,
  related_topics ARRAY,
  cultural_elements ARRAY,
  embedding USER-DEFINED,
  last_accessed timestamp with time zone DEFAULT now(),
  access_count integer DEFAULT 0,
  metadata jsonb,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT koru_context_memory_pkey PRIMARY KEY (id)
);
CREATE TABLE public.mataroa_audit_log (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  audit_id text NOT NULL UNIQUE,
  operation_type text NOT NULL,
  resource_type text NOT NULL,
  resource_id text,
  kaitiaki_agent text,
  user_session text,
  ip_address inet,
  operation_details jsonb DEFAULT '{}'::jsonb,
  cultural_validation jsonb DEFAULT '{}'::jsonb,
  before_state jsonb,
  after_state jsonb,
  success boolean DEFAULT true,
  error_message text,
  processing_time_ms integer,
  tapu_level integer DEFAULT 0,
  requires_review boolean DEFAULT false,
  cultural_themes ARRAY DEFAULT '{}'::text[],
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT mataroa_audit_log_pkey PRIMARY KEY (id)
);
CREATE TABLE public.matua_reflections (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  reflection_date date NOT NULL DEFAULT CURRENT_DATE,
  reflection_json jsonb NOT NULL,
  documents_processed integer DEFAULT 0,
  elder_reviews_triggered integer DEFAULT 0,
  tapu_flagged integer DEFAULT 0,
  drift_score numeric DEFAULT 0,
  guidance text,
  summary_te_reo text,
  created_by text DEFAULT 'Matua_Whiro'::text,
  linked_audit_id uuid,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT matua_reflections_pkey PRIMARY KEY (id),
  CONSTRAINT matua_reflections_linked_audit_id_fkey FOREIGN KEY (linked_audit_id) REFERENCES public.mataroa_audit_log(id)
);
CREATE TABLE public.processing_stats (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  stat_type text NOT NULL,
  stat_date date NOT NULL,
  documents_processed integer DEFAULT 0,
  total_characters_extracted bigint DEFAULT 0,
  total_embeddings_generated integer DEFAULT 0,
  average_processing_time_seconds numeric,
  chat_sessions_created integer DEFAULT 0,
  total_messages integer DEFAULT 0,
  kaitiaki_activations jsonb DEFAULT '{}'::jsonb,
  searches_performed integer DEFAULT 0,
  cultural_searches integer DEFAULT 0,
  tapu_content_flagged integer DEFAULT 0,
  elder_reviews_triggered integer DEFAULT 0,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT processing_stats_pkey PRIMARY KEY (id)
);
CREATE TABLE public.search_queries (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  query_text text NOT NULL,
  query_type text DEFAULT 'semantic'::text CHECK (query_type = ANY (ARRAY['semantic'::text, 'keyword'::text, 'cultural'::text, 'hybrid'::text])),
  cultural_filter text,
  results_count integer DEFAULT 0,
  user_session text,
  processing_time_ms integer,
  kaitiaki_agent text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT search_queries_pkey PRIMARY KEY (id)
);
CREATE TABLE public.translations (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid,
  source_text text NOT NULL,
  translated_text text NOT NULL,
  source_lang text DEFAULT 'en'::text,
  target_lang text DEFAULT 'mi'::text,
  translation_time timestamp with time zone DEFAULT now(),
  CONSTRAINT translations_pkey PRIMARY KEY (id)
);
CREATE TABLE public.user_searches (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  search_query text NOT NULL,
  search_time timestamp with time zone DEFAULT now(),
  results jsonb,
  CONSTRAINT user_searches_pkey PRIMARY KEY (id)
);
CREATE TABLE public.user_summaries (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  summary_text text NOT NULL,
  summary_time timestamp with time zone DEFAULT now(),
  context jsonb,
  CONSTRAINT user_summaries_pkey PRIMARY KEY (id)
);
CREATE TABLE public.whiro_context_memory (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid,
  context_type text NOT NULL,
  context_name text NOT NULL,
  context_description text,
  related_topics ARRAY,
  cultural_elements ARRAY,
  embedding USER-DEFINED,
  last_accessed timestamp with time zone DEFAULT now(),
  access_count integer DEFAULT 0,
  metadata jsonb,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT whiro_context_memory_pkey PRIMARY KEY (id)
);

kitenga schema 

-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE kitenga.artifacts (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  file_name text NOT NULL,
  file_type text NOT NULL,
  file_size_bytes integer,
  file_hash text NOT NULL,
  storage_path text NOT NULL,
  kaupapa_tags ARRAY DEFAULT '{}'::text[],
  tapu_level integer DEFAULT 0 CHECK (tapu_level >= 0 AND tapu_level <= 3),
  whakatauki text,
  summary text,
  full_text text,
  stance text,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT artifacts_pkey PRIMARY KEY (id),
  CONSTRAINT artifacts_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);
CREATE TABLE kitenga.chats (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  title text,
  kaitiaki_name text DEFAULT 'Aotahi'::text,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT chats_pkey PRIMARY KEY (id),
  CONSTRAINT chats_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);
CREATE TABLE kitenga.cultural_adaptations (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id text NOT NULL,
  adaptation_type text NOT NULL,
  adaptation_value text NOT NULL,
  effectiveness_score double precision,
  usage_count integer DEFAULT 0,
  last_used timestamp with time zone,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT cultural_adaptations_pkey PRIMARY KEY (id)
);
CREATE TABLE kitenga.kaitiaki_datasets (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name text NOT NULL,
  version text NOT NULL,
  storage_path text NOT NULL,
  checksum text NOT NULL,
  records integer,
  tags ARRAY DEFAULT '{}'::text[],
  notes text,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  CONSTRAINT kaitiaki_datasets_pkey PRIMARY KEY (id)
);
CREATE TABLE kitenga.kaitiaki_models (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  kaitiaki_name text NOT NULL,
  version text NOT NULL,
  dataset_id uuid,
  storage_path text NOT NULL,
  checksum text NOT NULL,
  adapter_type text DEFAULT 'lora'::text,
  framework text DEFAULT 'transformers'::text,
  eval_metrics jsonb,
  notes text,
  created_by text,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  is_active boolean DEFAULT false,
  CONSTRAINT kaitiaki_models_pkey PRIMARY KEY (id),
  CONSTRAINT kaitiaki_models_dataset_id_fkey FOREIGN KEY (dataset_id) REFERENCES kitenga.kaitiaki_datasets(id)
);
CREATE TABLE kitenga.kitenga_index (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  source text,
  source_id text,
  text text,
  embedding USER-DEFINED,
  CONSTRAINT kitenga_index_pkey PRIMARY KEY (id)
);
CREATE TABLE kitenga.memory_index (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  log_id uuid,
  content text,
  embedding USER-DEFINED,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT memory_index_pkey PRIMARY KEY (id),
  CONSTRAINT memory_index_log_id_fkey FOREIGN KEY (log_id) REFERENCES kitenga.memory_log(id)
);
CREATE TABLE kitenga.memory_log (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  source text,
  ref_id uuid,
  event_type text,
  summary text,
  details jsonb,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT memory_log_pkey PRIMARY KEY (id)
);
CREATE TABLE kitenga.messages (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  chat_id uuid NOT NULL,
  role text NOT NULL CHECK (role = ANY (ARRAY['user'::text, 'assistant'::text, 'system'::text])),
  content text NOT NULL,
  referenced_artifacts ARRAY DEFAULT '{}'::uuid[],
  metadata jsonb DEFAULT '{}'::jsonb,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT messages_pkey PRIMARY KEY (id),
  CONSTRAINT messages_chat_id_fkey FOREIGN KEY (chat_id) REFERENCES kitenga.chats(id)
);
CREATE TABLE kitenga.meta_assets (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  filename text NOT NULL,
  file_type text NOT NULL,
  file_size integer,
  content text,
  summary text,
  embedding USER-DEFINED,
  metadata jsonb,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT meta_assets_pkey PRIMARY KEY (id)
);
CREATE TABLE kitenga.meta_contexts (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id text NOT NULL,
  context_type text NOT NULL,
  context_name text NOT NULL,
  context_description text,
  related_topics ARRAY,
  cultural_elements ARRAY,
  current_status text,
  last_accessed timestamp with time zone DEFAULT now(),
  access_count integer DEFAULT 0,
  metadata jsonb,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT meta_contexts_pkey PRIMARY KEY (id)
);
CREATE TABLE kitenga.meta_documents (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  content text,
  metadata jsonb,
  embedding USER-DEFINED,
  embedded boolean DEFAULT true,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT meta_documents_pkey PRIMARY KEY (id)
);
CREATE TABLE kitenga.meta_embeddings (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  article_id uuid,
  embedding USER-DEFINED,
  metadata jsonb,
  model_used text,
  created_at timestamp with time zone DEFAULT now(),
  artifact_id uuid,
  chunk_index integer,
  chunk_text text,
  CONSTRAINT meta_embeddings_pkey PRIMARY KEY (id),
  CONSTRAINT embeddings_article_id_fkey FOREIGN KEY (article_id) REFERENCES kitenga.meta_sources(id),
  CONSTRAINT embeddings_artifact_id_fkey FOREIGN KEY (artifact_id) REFERENCES kitenga.artifacts(id)
);
CREATE TABLE kitenga.meta_messages (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  session_id uuid,
  role text NOT NULL,
  content text NOT NULL,
  metadata jsonb,
  user_satisfaction integer,
  cultural_relevance_score double precision,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT meta_messages_pkey PRIMARY KEY (id),
  CONSTRAINT chat_messages_session_id_fkey FOREIGN KEY (session_id) REFERENCES kitenga.orchestrators_conversations(id)
);
CREATE TABLE kitenga.meta_sources (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  title text NOT NULL,
  authors ARRAY,
  abstract text,
  content text NOT NULL,
  url text,
  doi text,
  publication_date date,
  source text,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT meta_sources_pkey PRIMARY KEY (id)
);
CREATE TABLE kitenga.meta_summaries (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  article_id uuid,
  summary text NOT NULL,
  key_points ARRAY,
  cultural_context text,
  maori_translation text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT meta_summaries_pkey PRIMARY KEY (id),
  CONSTRAINT summaries_article_id_fkey FOREIGN KEY (article_id) REFERENCES kitenga.meta_sources(id)
);
CREATE TABLE kitenga.orchestrators_conversations (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id text NOT NULL,
  session_name text,
  session_type text DEFAULT 'general'::text,
  context_summary text,
  emotional_tone text,
  topics_discussed ARRAY,
  cultural_elements ARRAY,
  satisfaction_rating integer,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT orchestrators_conversations_pkey PRIMARY KEY (id)
);
CREATE TABLE kitenga.prompts (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid,
  name text NOT NULL,
  content text NOT NULL,
  category text NOT NULL DEFAULT 'general'::text,
  tags ARRAY NOT NULL DEFAULT ARRAY[]::text[],
  metadata jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT prompts_pkey PRIMARY KEY (id),
  CONSTRAINT prompts_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);
CREATE TABLE kitenga.taonga_embeddings (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  summary_id uuid,
  content text NOT NULL,
  embedding USER-DEFINED NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  metadata jsonb,
  embedded boolean DEFAULT true,
  CONSTRAINT taonga_embeddings_pkey PRIMARY KEY (id),
  CONSTRAINT taonga_embeddings_summary_id_fkey FOREIGN KEY (summary_id) REFERENCES kitenga.taonga_summaries(id)
);
CREATE TABLE kitenga.taonga_queries (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  query_text text NOT NULL,
  matched_ids ARRAY,
  response text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT taonga_queries_pkey PRIMARY KEY (id)
);
CREATE TABLE kitenga.taonga_summaries (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  upload_id uuid,
  summary text NOT NULL,
  metadata jsonb DEFAULT '{}'::jsonb,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT taonga_summaries_pkey PRIMARY KEY (id),
  CONSTRAINT taonga_summaries_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES kitenga.taonga_uploads(id)
);
CREATE TABLE kitenga.taonga_uploads (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  file_name text NOT NULL,
  file_url text NOT NULL UNIQUE,
  uploaded_at timestamp with time zone DEFAULT now(),
  source text,
  title text,
  author text,
  published_at timestamp with time zone,
  content text,
  summary text,
  opinion text,
  citations jsonb,
  embedding USER-DEFINED,
  CONSTRAINT taonga_uploads_pkey PRIMARY KEY (id)
);
CREATE TABLE kitenga.ti_memory_backup (
  id uuid,
  user_id uuid,
  thread_id text,
  role text,
  content text,
  meta jsonb,
  embedding USER-DEFINED,
  created_at timestamp with time zone,
  pack_id text,
  pinned boolean,
  tsv tsvector,
  source text,
  message text,
  type text
);
CREATE TABLE kitenga.validators_audit (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  ts timestamp with time zone DEFAULT now(),
  route text NOT NULL,
  method text NOT NULL,
  status_code integer NOT NULL,
  user_id text,
  request_id text,
  ip text,
  agent text,
  action text,
  payload_hash text,
  redacted boolean DEFAULT true,
  cultural_flags jsonb,
  latency_ms integer,
  metadata jsonb,
  CONSTRAINT validators_audit_pkey PRIMARY KEY (id)
);
CREATE TABLE kitenga.validators_feedback (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id text NOT NULL,
  message_id uuid,
  feedback_type text NOT NULL,
  feedback_content text NOT NULL,
  cultural_context text,
  severity text DEFAULT 'minor'::text,
  resolved boolean DEFAULT false,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT validators_feedback_pkey PRIMARY KEY (id),
  CONSTRAINT user_feedback_message_id_fkey FOREIGN KEY (message_id) REFERENCES kitenga.meta_messages(id)
);
CREATE TABLE kitenga.validators_profiles (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id text NOT NULL UNIQUE,
  preferred_language text DEFAULT 'en'::text,
  cultural_comfort_level text DEFAULT 'beginner'::text,
  communication_style text DEFAULT 'balanced'::text,
  interests ARRAY,
  learning_goals ARRAY,
  maori_connection text,
  feedback_preferences jsonb,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT validators_profiles_pkey PRIMARY KEY (id)
);
CREATE TABLE kitenga.validators_relationships (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id text NOT NULL,
  relationship_phase text DEFAULT 'new'::text,
  trust_level double precision DEFAULT 0.5,
  cultural_comfort double precision DEFAULT 0.5,
  communication_effectiveness double precision DEFAULT 0.5,
  last_interaction timestamp with time zone,
  interaction_count integer DEFAULT 0,
  positive_interactions integer DEFAULT 0,
  cultural_learning_progress jsonb,
  personal_context jsonb,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT validators_relationships_pkey PRIMARY KEY (id)
);
CREATE TABLE kitenga.whakapapa_logs (
  id text NOT NULL,
  title text NOT NULL,
  category text DEFAULT 'whakapapa'::text,
  author text DEFAULT 'Kitenga'::text,
  summary text,
  content_type text DEFAULT 'text'::text,
  data jsonb,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT whakapapa_logs_pkey PRIMARY KEY (id)
);

-- 🛠 Tiwhanawhana schema

-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE tiwhanawhana.embeddings (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  content text,
  embedding USER-DEFINED,
  meta jsonb DEFAULT '{}'::jsonb,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT embeddings_pkey PRIMARY KEY (id)
);
CREATE TABLE tiwhanawhana.ocr_logs (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  file_name text,
  language text,
  extracted_text text,
  meta jsonb DEFAULT '{}'::jsonb,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT ocr_logs_pkey PRIMARY KEY (id)
);
CREATE TABLE tiwhanawhana.task_queue (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  task_type text,
  payload jsonb,
  assigned_to text,
  status text DEFAULT 'pending'::text,
  created_at timestamp with time zone DEFAULT now(),
  completed_at timestamp with time zone,
  CONSTRAINT task_queue_pkey PRIMARY KEY (id)
);
CREATE TABLE tiwhanawhana.ti_memory (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid,
  memory_type text DEFAULT 'reflection'::text,
  content text,
  meta jsonb DEFAULT '{}'::jsonb,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT ti_memory_pkey PRIMARY KEY (id)
);
CREATE TABLE tiwhanawhana.translations (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  source_text text,
  translated_text text,
  source_lang text,
  target_lang text,
  confidence numeric DEFAULT 1.0,
  meta jsonb DEFAULT '{}'::jsonb,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT translations_pkey PRIMARY KEY (id)
);

rongohia schema

-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE rongohia.artifacts (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  script_id uuid,
  output_type text,
  output_content text,
  meta jsonb,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT artifacts_pkey PRIMARY KEY (id),
  CONSTRAINT artifacts_script_id_fkey FOREIGN KEY (script_id) REFERENCES rongohia.scripts(id)
);
CREATE TABLE rongohia.audit_logs (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  action text,
  admin_user_id uuid,
  target_user_id uuid,
  details text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT audit_logs_pkey PRIMARY KEY (id)
);
CREATE TABLE rongohia.carver_memory (
  user_id uuid NOT NULL,
  interests ARRAY,
  verification_style text,
  trust_level integer,
  language_preference text,
  last_updated timestamp with time zone,
  CONSTRAINT carver_memory_pkey PRIMARY KEY (user_id)
);
CREATE TABLE rongohia.carvings (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  script_id uuid,
  artifact_id uuid,
  status text DEFAULT 'complete'::text,
  feedback text,
  created_at timestamp with time zone DEFAULT now(),
  validation_id uuid,
  CONSTRAINT carvings_pkey PRIMARY KEY (id),
  CONSTRAINT carvings_script_id_fkey FOREIGN KEY (script_id) REFERENCES rongohia.scripts(id),
  CONSTRAINT carvings_artifact_id_fkey FOREIGN KEY (artifact_id) REFERENCES rongohia.artifacts(id),
  CONSTRAINT carvings_validation_id_fkey FOREIGN KEY (validation_id) REFERENCES whiro.validation_logs(id)
);
CREATE TABLE rongohia.chat_sessions (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid,
  title text,
  created_at timestamp with time zone DEFAULT now(),
  last_message_at timestamp with time zone,
  message_count integer,
  CONSTRAINT chat_sessions_pkey PRIMARY KEY (id)
);
CREATE TABLE rongohia.config_files (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  filename text,
  file_type text,
  content text,
  tags ARRAY,
  access_level text,
  version integer,
  created_by uuid,
  created_at timestamp with time zone DEFAULT now(),
  description text,
  CONSTRAINT config_files_pkey PRIMARY KEY (id)
);
CREATE TABLE rongohia.config_versions (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  config_id uuid,
  version integer,
  content text,
  created_by uuid,
  created_at timestamp with time zone DEFAULT now(),
  change_note text,
  CONSTRAINT config_versions_pkey PRIMARY KEY (id)
);
CREATE TABLE rongohia.messages (
  id bigint NOT NULL DEFAULT nextval('rongohia.messages_id_seq'::regclass),
  user_id uuid,
  session_id text,
  role text,
  content text,
  genealogy_context jsonb,
  created_at timestamp with time zone DEFAULT now(),
  embedding USER-DEFINED,
  CONSTRAINT messages_pkey PRIMARY KEY (id)
);
CREATE TABLE rongohia.meta (
  id bigint NOT NULL DEFAULT nextval('rongohia.meta_id_seq'::regclass),
  timestamp timestamp with time zone DEFAULT now(),
  rotation_nonce text NOT NULL,
  signature text NOT NULL,
  source text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT meta_pkey PRIMARY KEY (id)
);
CREATE TABLE rongohia.prompts (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  session_id text,
  prompt text,
  model text,
  timestamp timestamp with time zone DEFAULT now(),
  CONSTRAINT prompts_pkey PRIMARY KEY (id)
);
CREATE TABLE rongohia.scripts (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  title text,
  content text,
  type text DEFAULT 'prompt'::text,
  author text,
  tags ARRAY,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT scripts_pkey PRIMARY KEY (id)
);
create table if not exists ti_env_seals (
  id bigint generated always as identity primary key,
  mauri_hash text not null,
  sealed_at timestamptz default now(),
  environment jsonb,
  kaitiaki jsonb,
  supabase_tables text[]
);
CREATE TABLE rongohia.user_profiles (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid,
  display_name text,
  preferences jsonb,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT user_profiles_pkey PRIMARY KEY (id)
);