$ psql "$DEN_URL" <<'SQL'
-- Reassign ownership of every schema to postgres
DO $$
DECLARE s text;
BEGIN
  FOR s IN
    SELECT schema_name
    FROM information_schema.schemata
    WHERE schema_name NOT IN ('pg_catalog','information_schema')
  LOOP
    EXECUTE format('ALTER SCHEMA %I OWNER TO postgres;', s);
  END LOOP;
END$$;

-- Reassign ownership of every table, sequence, view, and function
DO $$
DECLARE obj record;
BEGIN
  FOR obj IN
    SELECT 'table' AS type, table_schema AS schema, table_name AS name
      FROM information_schema.tables
      WHERE table_schema NOT IN ('pg_catalog','information_schema')
    UNION ALL
    SELECT 'sequence', sequence_schema, sequence_name
SQLER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO postgres;ma, ob
ERROR:  must be owner of schema pg_toast
CONTEXT:  SQL statement "ALTER SCHEMA pg_toast OWNER TO postgres;"
PL/pgSQL function inline_code_block line 9 at EXECUTE
ERROR:  syntax error at or near "ON"
LINE 14:     ON CONFLICT DO NOTHING;
             ^
ALTER DEFAULT PRIVILEGES
hemi-whiro@hemi-whiro-B150M-D3H:~/Desktop$ psql "$DEN_URL" <<'SQL'
-- List any objects not owned by postgres
SELECT n.nspname AS schema,
       c.relname AS object,
       r.rolname AS owner
FROM pg_class c
JOIN pg_roles r ON r.oid = c.relowner
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE n.nspname NOT IN ('pg_catalog','information_schema')
  AND r.rolname <> 'postgres'
ORDER BY n.nspname, c.relname;

-- Check functions
SELECT n.nspname AS schema,
       p.proname AS function,
       r.rolname AS owner
FROM pg_proc p
JOIN pg_roles r ON r.oid = p.proowner
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname NOT IN ('pg_catalog','information_schema')
  AND r.rolname <> 'postgres'
ORDER BY n.nspname, p.proname;

-- Verify that each schema has usage privileges for postgres
SELECT schema_name, has_schema_privilege('postgres', schema_name, 'USAGE') AS haSQLER BY schema_name; IN ('pg_catalog','information_schema')
       schema       |                        object                        |          owner           
--------------------+------------------------------------------------------+--------------------------
 auth               | amr_id_pk                                            | supabase_auth_admin
 auth               | audit_log_entries                                    | supabase_auth_admin
 auth               | audit_log_entries_pkey                               | supabase_auth_admin
 auth               | audit_logs_instance_id_idx                           | supabase_auth_admin
 auth               | confirmation_token_idx                               | supabase_auth_admin
 auth               | email_change_token_current_idx                       | supabase_auth_admin
 auth               | email_change_token_new_idx                           | supabase_auth_admin
 auth               | factor_id_created_at_idx                             | supabase_auth_admin
 auth               | flow_state                                           | supabase_auth_admin
 auth               | flow_state_created_at_idx                            | supabase_auth_admin
 auth               | flow_state_pkey                                      | supabase_auth_admin
 auth               | identities                                           | supabase_auth_admin
 auth               | identities_email_idx                                 | supabase_auth_admin
 auth               | identities_pkey                                      | supabase_auth_admin
 auth               | identities_provider_id_provider_unique               | supabase_auth_admin
 auth               | identities_user_id_idx                               | supabase_auth_admin
 auth               | idx_auth_code                                        | supabase_auth_admin
 auth               | idx_user_id_auth_method                              | supabase_auth_admin
 auth               | instances                                            | supabase_auth_admin
 auth               | instances_pkey                                       | supabase_auth_admin
 auth               | mfa_amr_claims                                       | supabase_auth_admin
 auth               | mfa_amr_claims_session_id_authentication_method_pkey | supabase_auth_admin
 auth               | mfa_challenge_created_at_idx                         | supabase_auth_admin
 auth               | mfa_challenges                                       | supabase_auth_admin
 auth               | mfa_challenges_pkey                                  | supabase_auth_admin
 auth               | mfa_factors                                          | supabase_auth_admin
 auth               | mfa_factors_last_challenged_at_key                   | supabase_auth_admin
 auth               | mfa_factors_pkey                                     | supabase_auth_admin
 auth               | mfa_factors_user_friendly_name_unique                | supabase_auth_admin
 auth               | mfa_factors_user_id_idx                              | supabase_auth_admin
 auth               | oauth_auth_pending_exp_idx                           | supabase_auth_admin
 auth               | oauth_authorizations                                 | supabase_auth_admin
 auth               | oauth_authorizations_authorization_code_key          | supabase_auth_admin
 auth               | oauth_authorizations_authorization_id_key            | supabase_auth_admin
 auth               | oauth_authorizations_pkey                            | supabase_auth_admin
 auth               | oauth_clients                                        | supabase_auth_admin
 auth               | oauth_clients_deleted_at_idx                         | supabase_auth_admin
 auth               | oauth_clients_pkey                                   | supabase_auth_admin
 auth               | oauth_consents                                       | supabase_auth_admin
 auth               | oauth_consents_active_client_idx                     | supabase_auth_admin
 auth               | oauth_consents_active_user_client_idx                | supabase_auth_admin
 auth               | oauth_consents_pkey                                  | supabase_auth_admin
 auth               | oauth_consents_user_client_unique                    | supabase_auth_admin
 auth               | oauth_consents_user_order_idx                        | supabase_auth_admin
 auth               | one_time_tokens                                      | supabase_auth_admin
 auth               | one_time_tokens_pkey                                 | supabase_auth_admin
 auth               | one_time_tokens_relates_to_hash_idx                  | supabase_auth_admin
 auth               | one_time_tokens_token_hash_hash_idx                  | supabase_auth_admin
 auth               | one_time_tokens_user_id_token_type_key               | supabase_auth_admin
 auth               | reauthentication_token_idx                           | supabase_auth_admin
 auth               | recovery_token_idx                                   | supabase_auth_admin
 auth               | refresh_tokens                                       | supabase_auth_admin
 auth               | refresh_tokens_id_seq                                | supabase_auth_admin
 auth               | refresh_tokens_instance_id_idx                       | supabase_auth_admin
 auth               | refresh_tokens_instance_id_user_id_idx               | supabase_auth_admin
 auth               | refresh_tokens_parent_idx                            | supabase_auth_admin
 auth               | refresh_tokens_pkey                                  | supabase_auth_admin
 auth               | refresh_tokens_session_id_revoked_idx                | supabase_auth_admin
 auth               | refresh_tokens_token_unique                          | supabase_auth_admin
 auth               | refresh_tokens_updated_at_idx                        | supabase_auth_admin
 auth               | saml_providers                                       | supabase_auth_admin
 auth               | saml_providers_entity_id_key                         | supabase_auth_admin
 auth               | saml_providers_pkey                                  | supabase_auth_admin
 auth               | saml_providers_sso_provider_id_idx                   | supabase_auth_admin
 auth               | saml_relay_states                                    | supabase_auth_admin
 auth               | saml_relay_states_created_at_idx                     | supabase_auth_admin
 auth               | saml_relay_states_for_email_idx                      | supabase_auth_admin
 auth               | saml_relay_states_pkey                               | supabase_auth_admin
 auth               | saml_relay_states_sso_provider_id_idx                | supabase_auth_admin
 auth               | schema_migrations                                    | supabase_auth_admin
 auth               | schema_migrations_pkey                               | supabase_auth_admin
 auth               | sessions                                             | supabase_auth_admin
 auth               | sessions_not_after_idx                               | supabase_auth_admin
 auth               | sessions_oauth_client_id_idx                         | supabase_auth_admin
 auth               | sessions_pkey                                        | supabase_auth_admin
 auth               | sessions_user_id_idx                                 | supabase_auth_admin
 auth               | sso_domains                                          | supabase_auth_admin
 auth               | sso_domains_domain_idx                               | supabase_auth_admin
 auth               | sso_domains_pkey                                     | supabase_auth_admin
 auth               | sso_domains_sso_provider_id_idx                      | supabase_auth_admin
 auth               | sso_providers                                        | supabase_auth_admin
 auth               | sso_providers_pkey                                   | supabase_auth_admin
 auth               | sso_providers_resource_id_idx                        | supabase_auth_admin
 auth               | sso_providers_resource_id_pattern_idx                | supabase_auth_admin
 auth               | unique_phone_factor_per_user                         | supabase_auth_admin
 auth               | user_id_created_at_idx                               | supabase_auth_admin
 auth               | users                                                | supabase_auth_admin
 auth               | users_email_partial_key                              | supabase_auth_admin
 auth               | users_instance_id_email_idx                          | supabase_auth_admin
 auth               | users_instance_id_idx                                | supabase_auth_admin
 auth               | users_is_anonymous_idx                               | supabase_auth_admin
 auth               | users_phone_key                                      | supabase_auth_admin
 auth               | users_pkey                                           | supabase_auth_admin
 graphql            | seq_schema_version                                   | supabase_admin
 net                | _http_response                                       | supabase_admin
 net                | _http_response_created_idx                           | supabase_admin
 net                | http_request_queue                                   | supabase_admin
 net                | http_request_queue_id_seq                            | supabase_admin
 net                | http_response                                        | supabase_admin
 net                | http_response_result                                 | supabase_admin
 pg_toast           | pg_toast_1213                                        | supabase_admin
 pg_toast           | pg_toast_1213_index                                  | supabase_admin
 pg_toast           | pg_toast_1247                                        | supabase_admin
 pg_toast           | pg_toast_1247_index                                  | supabase_admin
 pg_toast           | pg_toast_1255                                        | supabase_admin
 pg_toast           | pg_toast_1255_index                                  | supabase_admin
 pg_toast           | pg_toast_1260                                        | supabase_admin
 pg_toast           | pg_toast_1260_index                                  | supabase_admin
 pg_toast           | pg_toast_1262                                        | supabase_admin
 pg_toast           | pg_toast_1262_index                                  | supabase_admin
 pg_toast           | pg_toast_13401                                       | supabase_admin
 pg_toast           | pg_toast_13401_index                                 | supabase_admin
 pg_toast           | pg_toast_13406                                       | supabase_admin
 pg_toast           | pg_toast_13406_index                                 | supabase_admin
 pg_toast           | pg_toast_13411                                       | supabase_admin
 pg_toast           | pg_toast_13411_index                                 | supabase_admin
 pg_toast           | pg_toast_13416                                       | supabase_admin
 pg_toast           | pg_toast_13416_index                                 | supabase_admin
 pg_toast           | pg_toast_1417                                        | supabase_admin
 pg_toast           | pg_toast_1417_index                                  | supabase_admin
 pg_toast           | pg_toast_1418                                        | supabase_admin
 pg_toast           | pg_toast_1418_index                                  | supabase_admin
 pg_toast           | pg_toast_16495                                       | supabase_auth_admin
 pg_toast           | pg_toast_16495_index                                 | supabase_auth_admin
 pg_toast           | pg_toast_16507                                       | supabase_auth_admin
 pg_toast           | pg_toast_16507_index                                 | supabase_auth_admin
 pg_toast           | pg_toast_16518                                       | supabase_auth_admin
 pg_toast           | pg_toast_16518_index                                 | supabase_auth_admin
 pg_toast           | pg_toast_16525                                       | supabase_auth_admin
 pg_toast           | pg_toast_16525_index                                 | supabase_auth_admin
 pg_toast           | pg_toast_16546                                       | supabase_storage_admin
 pg_toast           | pg_toast_16546_index                                 | supabase_storage_admin
 pg_toast           | pg_toast_16561                                       | supabase_storage_admin
 pg_toast           | pg_toast_16561_index                                 | supabase_storage_admin
 pg_toast           | pg_toast_16658                                       | supabase_admin
 pg_toast           | pg_toast_16658_index                                 | supabase_admin
 pg_toast           | pg_toast_16725                                       | supabase_auth_admin
 pg_toast           | pg_toast_16725_index                                 | supabase_auth_admin
 pg_toast           | pg_toast_16755                                       | supabase_auth_admin
 pg_toast           | pg_toast_16755_index                                 | supabase_auth_admin
 pg_toast           | pg_toast_16789                                       | supabase_auth_admin
 pg_toast           | pg_toast_16789_index                                 | supabase_auth_admin
 pg_toast           | pg_toast_16802                                       | supabase_auth_admin
 pg_toast           | pg_toast_16802_index                                 | supabase_auth_admin
 pg_toast           | pg_toast_16814                                       | supabase_auth_admin
 pg_toast           | pg_toast_16814_index                                 | supabase_auth_admin
 pg_toast           | pg_toast_16832                                       | supabase_auth_admin
 pg_toast           | pg_toast_16832_index                                 | supabase_auth_admin
 pg_toast           | pg_toast_16841                                       | supabase_auth_admin
 pg_toast           | pg_toast_16841_index                                 | supabase_auth_admin
 pg_toast           | pg_toast_16856                                       | supabase_auth_admin
 pg_toast           | pg_toast_16856_index                                 | supabase_auth_admin
 pg_toast           | pg_toast_16874                                       | supabase_auth_admin
 pg_toast           | pg_toast_16874_index                                 | supabase_auth_admin
 pg_toast           | pg_toast_16927                                       | supabase_auth_admin
 pg_toast           | pg_toast_16927_index                                 | supabase_auth_admin
 pg_toast           | pg_toast_16977                                       | supabase_auth_admin
 pg_toast           | pg_toast_16977_index                                 | supabase_auth_admin
 pg_toast           | pg_toast_17009                                       | supabase_auth_admin
 pg_toast           | pg_toast_17009_index                                 | supabase_auth_admin
 pg_toast           | pg_toast_17062                                       | supabase_storage_admin
 pg_toast           | pg_toast_17062_index                                 | supabase_storage_admin
 pg_toast           | pg_toast_17076                                       | supabase_storage_admin
 pg_toast           | pg_toast_17076_index                                 | supabase_storage_admin
 pg_toast           | pg_toast_17115                                       | supabase_storage_admin
 pg_toast           | pg_toast_17115_index                                 | supabase_storage_admin
 pg_toast           | pg_toast_17161                                       | supabase_admin
 pg_toast           | pg_toast_17161_index                                 | supabase_admin
 pg_toast           | pg_toast_17190                                       | supabase_storage_admin
 pg_toast           | pg_toast_17190_index                                 | supabase_storage_admin
 pg_toast           | pg_toast_21799                                       | supabase_auth_admin
 pg_toast           | pg_toast_21799_index                                 | supabase_auth_admin
 pg_toast           | pg_toast_21832                                       | supabase_auth_admin
 pg_toast           | pg_toast_21832_index                                 | supabase_auth_admin
 pg_toast           | pg_toast_2328                                        | supabase_admin
 pg_toast           | pg_toast_2328_index                                  | supabase_admin
 pg_toast           | pg_toast_2396                                        | supabase_admin
 pg_toast           | pg_toast_2396_index                                  | supabase_admin
 pg_toast           | pg_toast_2600                                        | supabase_admin
 pg_toast           | pg_toast_2600_index                                  | supabase_admin
 pg_toast           | pg_toast_2604                                        | supabase_admin
 pg_toast           | pg_toast_2604_index                                  | supabase_admin
 pg_toast           | pg_toast_2606                                        | supabase_admin
 pg_toast           | pg_toast_2606_index                                  | supabase_admin
 pg_toast           | pg_toast_2609                                        | supabase_admin
 pg_toast           | pg_toast_2609_index                                  | supabase_admin
 pg_toast           | pg_toast_2612                                        | supabase_admin
 pg_toast           | pg_toast_2612_index                                  | supabase_admin
 pg_toast           | pg_toast_2615                                        | supabase_admin
 pg_toast           | pg_toast_2615_index                                  | supabase_admin
 pg_toast           | pg_toast_2618                                        | supabase_admin
 pg_toast           | pg_toast_2618_index                                  | supabase_admin
 pg_toast           | pg_toast_2619                                        | supabase_admin
 pg_toast           | pg_toast_2619_index                                  | supabase_admin
 pg_toast           | pg_toast_2620                                        | supabase_admin
 pg_toast           | pg_toast_2620_index                                  | supabase_admin
 pg_toast           | pg_toast_29635                                       | supabase_admin
 pg_toast           | pg_toast_29635_index                                 | supabase_admin
 pg_toast           | pg_toast_2964                                        | supabase_admin
 pg_toast           | pg_toast_29642                                       | supabase_admin
 pg_toast           | pg_toast_29642_index                                 | supabase_admin
 pg_toast           | pg_toast_2964_index                                  | supabase_admin
 pg_toast           | pg_toast_29677                                       | supabase_functions_admin
 pg_toast           | pg_toast_29677_index                                 | supabase_functions_admin
 pg_toast           | pg_toast_29686                                       | supabase_functions_admin
 pg_toast           | pg_toast_29686_index                                 | supabase_functions_admin
 pg_toast           | pg_toast_3079                                        | supabase_admin
 pg_toast           | pg_toast_3079_index                                  | supabase_admin
 pg_toast           | pg_toast_3118                                        | supabase_admin
 pg_toast           | pg_toast_3118_index                                  | supabase_admin
 pg_toast           | pg_toast_3256                                        | supabase_admin
 pg_toast           | pg_toast_3256_index                                  | supabase_admin
 pg_toast           | pg_toast_3350                                        | supabase_admin
 pg_toast           | pg_toast_3350_index                                  | supabase_admin
 pg_toast           | pg_toast_3381                                        | supabase_admin
 pg_toast           | pg_toast_3381_index                                  | supabase_admin
 pg_toast           | pg_toast_3394                                        | supabase_admin
 pg_toast           | pg_toast_3394_index                                  | supabase_admin
 pg_toast           | pg_toast_3429                                        | supabase_admin
 pg_toast           | pg_toast_3429_index                                  | supabase_admin
 pg_toast           | pg_toast_3456                                        | supabase_admin
 pg_toast           | pg_toast_3456_index                                  | supabase_admin
 pg_toast           | pg_toast_3466                                        | supabase_admin
 pg_toast           | pg_toast_3466_index                                  | supabase_admin
 pg_toast           | pg_toast_3592                                        | supabase_admin
 pg_toast           | pg_toast_3592_index                                  | supabase_admin
 pg_toast           | pg_toast_3596                                        | supabase_admin
 pg_toast           | pg_toast_3596_index                                  | supabase_admin
 pg_toast           | pg_toast_3600                                        | supabase_admin
 pg_toast           | pg_toast_3600_index                                  | supabase_admin
 pg_toast           | pg_toast_6000                                        | supabase_admin
 pg_toast           | pg_toast_6000_index                                  | supabase_admin
 pg_toast           | pg_toast_6100                                        | supabase_admin
 pg_toast           | pg_toast_6100_index                                  | supabase_admin
 pg_toast           | pg_toast_6106                                        | supabase_admin
 pg_toast           | pg_toast_6106_index                                  | supabase_admin
 pg_toast           | pg_toast_6243                                        | supabase_admin
 pg_toast           | pg_toast_6243_index                                  | supabase_admin
 pg_toast           | pg_toast_826                                         | supabase_admin
 pg_toast           | pg_toast_826_index                                   | supabase_admin
 realtime           | ix_realtime_subscription_entity                      | supabase_admin
 realtime           | messages                                             | supabase_realtime_admin
 realtime           | messages_inserted_at_topic_index                     | supabase_realtime_admin
 realtime           | messages_pkey                                        | supabase_realtime_admin
 realtime           | pk_subscription                                      | supabase_admin
 realtime           | schema_migrations                                    | supabase_admin
 realtime           | schema_migrations_pkey                               | supabase_admin
 realtime           | subscription                                         | supabase_admin
 realtime           | subscription_id_seq                                  | supabase_admin
 realtime           | subscription_subscription_id_entity_filters_key      | supabase_admin
 realtime           | user_defined_filter                                  | supabase_admin
 realtime           | wal_column                                           | supabase_admin
 realtime           | wal_rls                                              | supabase_admin
 storage            | bname                                                | supabase_storage_admin
 storage            | bucketid_objname                                     | supabase_storage_admin
 storage            | buckets                                              | supabase_storage_admin
 storage            | buckets_analytics                                    | supabase_storage_admin
 storage            | buckets_analytics_pkey                               | supabase_storage_admin
 storage            | buckets_pkey                                         | supabase_storage_admin
 storage            | idx_multipart_uploads_list                           | supabase_storage_admin
 storage            | idx_name_bucket_level_unique                         | supabase_storage_admin
 storage            | idx_objects_bucket_id_name                           | supabase_storage_admin
 storage            | idx_objects_lower_name                               | supabase_storage_admin
 storage            | idx_prefixes_lower_name                              | supabase_storage_admin
 storage            | migrations                                           | supabase_storage_admin
 storage            | migrations_name_key                                  | supabase_storage_admin
 storage            | migrations_pkey                                      | supabase_storage_admin
 storage            | name_prefix_search                                   | supabase_storage_admin
 storage            | objects                                              | supabase_storage_admin
 storage            | objects_bucket_id_level_idx                          | supabase_storage_admin
 storage            | objects_pkey                                         | supabase_storage_admin
 storage            | prefixes                                             | supabase_storage_admin
 storage            | prefixes_pkey                                        | supabase_storage_admin
 storage            | s3_multipart_uploads                                 | supabase_storage_admin
 storage            | s3_multipart_uploads_parts                           | supabase_storage_admin
 storage            | s3_multipart_uploads_parts_pkey                      | supabase_storage_admin
 storage            | s3_multipart_uploads_pkey                            | supabase_storage_admin
 supabase_functions | hooks                                                | supabase_functions_admin
 supabase_functions | hooks_id_seq                                         | supabase_functions_admin
 supabase_functions | hooks_pkey                                           | supabase_functions_admin
 supabase_functions | migrations                                           | supabase_functions_admin
 supabase_functions | migrations_pkey                                      | supabase_functions_admin
 supabase_functions | supabase_functions_hooks_h_table_id_h_name_idx       | supabase_functions_admin
 supabase_functions | supabase_functions_hooks_request_id_idx              | supabase_functions_admin
 vault              | decrypted_secrets                                    | supabase_admin
 vault              | secrets                                              | supabase_admin
 vault              | secrets_name_idx                                     | supabase_admin
 vault              | secrets_pkey                                         | supabase_admin
(288 rows)

       schema       |                 function                  |          owner           
--------------------+-------------------------------------------+--------------------------
 auth               | email                                     | supabase_auth_admin
 auth               | jwt                                       | supabase_auth_admin
 auth               | role                                      | supabase_auth_admin
 auth               | uid                                       | supabase_auth_admin
 extensions         | grant_pg_cron_access                      | supabase_admin
 extensions         | grant_pg_graphql_access                   | supabase_admin
 extensions         | grant_pg_net_access                       | supabase_admin
 extensions         | pgrst_ddl_watch                           | supabase_admin
 extensions         | pgrst_drop_watch                          | supabase_admin
 extensions         | set_graphql_placeholder                   | supabase_admin
 graphql            | _internal_resolve                         | supabase_admin
 graphql            | comment_directive                         | supabase_admin
 graphql            | exception                                 | supabase_admin
 graphql            | get_schema_version                        | supabase_admin
 graphql            | increment_schema_version                  | supabase_admin
 graphql            | resolve                                   | supabase_admin
 graphql_public     | graphql                                   | supabase_admin
 net                | _await_response                           | supabase_admin
 net                | _encode_url_with_params_array             | supabase_admin
 net                | _http_collect_response                    | supabase_admin
 net                | _urlencode_string                         | supabase_admin
 net                | check_worker_is_up                        | supabase_admin
 net                | http_collect_response                     | supabase_admin
 net                | http_delete                               | supabase_admin
 net                | http_get                                  | supabase_admin
 net                | http_post                                 | supabase_admin
 net                | wait_until_running                        | supabase_admin
 net                | wake                                      | supabase_admin
 net                | worker_restart                            | supabase_admin
 pgbouncer          | get_auth                                  | supabase_admin
 public             | array_to_halfvec                          | supabase_admin
 public             | array_to_halfvec                          | supabase_admin
 public             | array_to_halfvec                          | supabase_admin
 public             | array_to_halfvec                          | supabase_admin
 public             | array_to_sparsevec                        | supabase_admin
 public             | array_to_sparsevec                        | supabase_admin
 public             | array_to_sparsevec                        | supabase_admin
 public             | array_to_sparsevec                        | supabase_admin
 public             | array_to_vector                           | supabase_admin
 public             | array_to_vector                           | supabase_admin
 public             | array_to_vector                           | supabase_admin
 public             | array_to_vector                           | supabase_admin
 public             | avg                                       | supabase_admin
 public             | avg                                       | supabase_admin
 public             | binary_quantize                           | supabase_admin
 public             | binary_quantize                           | supabase_admin
 public             | cosine_distance                           | supabase_admin
 public             | cosine_distance                           | supabase_admin
 public             | cosine_distance                           | supabase_admin
 public             | gin_extract_query_trgm                    | supabase_admin
 public             | gin_extract_value_trgm                    | supabase_admin
 public             | gin_trgm_consistent                       | supabase_admin
 public             | gin_trgm_triconsistent                    | supabase_admin
 public             | gtrgm_compress                            | supabase_admin
 public             | gtrgm_consistent                          | supabase_admin
 public             | gtrgm_decompress                          | supabase_admin
 public             | gtrgm_distance                            | supabase_admin
 public             | gtrgm_in                                  | supabase_admin
 public             | gtrgm_options                             | supabase_admin
 public             | gtrgm_out                                 | supabase_admin
 public             | gtrgm_penalty                             | supabase_admin
 public             | gtrgm_picksplit                           | supabase_admin
 public             | gtrgm_same                                | supabase_admin
 public             | gtrgm_union                               | supabase_admin
 public             | halfvec                                   | supabase_admin
 public             | halfvec_accum                             | supabase_admin
 public             | halfvec_add                               | supabase_admin
 public             | halfvec_avg                               | supabase_admin
 public             | halfvec_cmp                               | supabase_admin
 public             | halfvec_combine                           | supabase_admin
 public             | halfvec_concat                            | supabase_admin
 public             | halfvec_eq                                | supabase_admin
 public             | halfvec_ge                                | supabase_admin
 public             | halfvec_gt                                | supabase_admin
 public             | halfvec_in                                | supabase_admin
 public             | halfvec_l2_squared_distance               | supabase_admin
 public             | halfvec_le                                | supabase_admin
 public             | halfvec_lt                                | supabase_admin
 public             | halfvec_mul                               | supabase_admin
 public             | halfvec_ne                                | supabase_admin
 public             | halfvec_negative_inner_product            | supabase_admin
 public             | halfvec_out                               | supabase_admin
 public             | halfvec_recv                              | supabase_admin
 public             | halfvec_send                              | supabase_admin
 public             | halfvec_spherical_distance                | supabase_admin
 public             | halfvec_sub                               | supabase_admin
 public             | halfvec_to_float4                         | supabase_admin
 public             | halfvec_to_sparsevec                      | supabase_admin
 public             | halfvec_to_vector                         | supabase_admin
 public             | halfvec_typmod_in                         | supabase_admin
 public             | hamming_distance                          | supabase_admin
 public             | hnsw_bit_support                          | supabase_admin
 public             | hnsw_halfvec_support                      | supabase_admin
 public             | hnsw_sparsevec_support                    | supabase_admin
 public             | hnswhandler                               | supabase_admin
 public             | inner_product                             | supabase_admin
 public             | inner_product                             | supabase_admin
 public             | inner_product                             | supabase_admin
 public             | ivfflat_bit_support                       | supabase_admin
 public             | ivfflat_halfvec_support                   | supabase_admin
 public             | ivfflathandler                            | supabase_admin
 public             | jaccard_distance                          | supabase_admin
 public             | l1_distance                               | supabase_admin
 public             | l1_distance                               | supabase_admin
 public             | l1_distance                               | supabase_admin
 public             | l2_distance                               | supabase_admin
 public             | l2_distance                               | supabase_admin
 public             | l2_distance                               | supabase_admin
 public             | l2_norm                                   | supabase_admin
 public             | l2_norm                                   | supabase_admin
 public             | l2_normalize                              | supabase_admin
 public             | l2_normalize                              | supabase_admin
 public             | l2_normalize                              | supabase_admin
 public             | set_limit                                 | supabase_admin
 public             | show_limit                                | supabase_admin
 public             | show_trgm                                 | supabase_admin
 public             | similarity                                | supabase_admin
 public             | similarity_dist                           | supabase_admin
 public             | similarity_op                             | supabase_admin
 public             | sparsevec                                 | supabase_admin
 public             | sparsevec_cmp                             | supabase_admin
 public             | sparsevec_eq                              | supabase_admin
 public             | sparsevec_ge                              | supabase_admin
 public             | sparsevec_gt                              | supabase_admin
 public             | sparsevec_in                              | supabase_admin
 public             | sparsevec_l2_squared_distance             | supabase_admin
 public             | sparsevec_le                              | supabase_admin
 public             | sparsevec_lt                              | supabase_admin
 public             | sparsevec_ne                              | supabase_admin
 public             | sparsevec_negative_inner_product          | supabase_admin
 public             | sparsevec_out                             | supabase_admin
 public             | sparsevec_recv                            | supabase_admin
 public             | sparsevec_send                            | supabase_admin
 public             | sparsevec_to_halfvec                      | supabase_admin
 public             | sparsevec_to_vector                       | supabase_admin
 public             | sparsevec_typmod_in                       | supabase_admin
 public             | strict_word_similarity                    | supabase_admin
 public             | strict_word_similarity_commutator_op      | supabase_admin
 public             | strict_word_similarity_dist_commutator_op | supabase_admin
 public             | strict_word_similarity_dist_op            | supabase_admin
 public             | strict_word_similarity_op                 | supabase_admin
 public             | subvector                                 | supabase_admin
 public             | subvector                                 | supabase_admin
 public             | sum                                       | supabase_admin
 public             | sum                                       | supabase_admin
 public             | vector                                    | supabase_admin
 public             | vector_accum                              | supabase_admin
 public             | vector_add                                | supabase_admin
 public             | vector_avg                                | supabase_admin
 public             | vector_cmp                                | supabase_admin
 public             | vector_combine                            | supabase_admin
 public             | vector_concat                             | supabase_admin
 public             | vector_dims                               | supabase_admin
 public             | vector_dims                               | supabase_admin
 public             | vector_eq                                 | supabase_admin
 public             | vector_ge                                 | supabase_admin
 public             | vector_gt                                 | supabase_admin
 public             | vector_in                                 | supabase_admin
 public             | vector_l2_squared_distance                | supabase_admin
 public             | vector_le                                 | supabase_admin
 public             | vector_lt                                 | supabase_admin
 public             | vector_mul                                | supabase_admin
 public             | vector_ne                                 | supabase_admin
 public             | vector_negative_inner_product             | supabase_admin
 public             | vector_norm                               | supabase_admin
 public             | vector_out                                | supabase_admin
 public             | vector_recv                               | supabase_admin
 public             | vector_send                               | supabase_admin
 public             | vector_spherical_distance                 | supabase_admin
 public             | vector_sub                                | supabase_admin
 public             | vector_to_float4                          | supabase_admin
 public             | vector_to_halfvec                         | supabase_admin
 public             | vector_to_sparsevec                       | supabase_admin
 public             | vector_typmod_in                          | supabase_admin
 public             | word_similarity                           | supabase_admin
 public             | word_similarity_commutator_op             | supabase_admin
 public             | word_similarity_dist_commutator_op        | supabase_admin
 public             | word_similarity_dist_op                   | supabase_admin
 public             | word_similarity_op                        | supabase_admin
 realtime           | apply_rls                                 | supabase_admin
 realtime           | broadcast_changes                         | supabase_admin
 realtime           | build_prepared_statement_sql              | supabase_admin
 realtime           | cast                                      | supabase_admin
 realtime           | check_equality_op                         | supabase_admin
 realtime           | is_visible_through_filters                | supabase_admin
 realtime           | list_changes                              | supabase_admin
 realtime           | quote_wal2json                            | supabase_admin
 realtime           | send                                      | supabase_admin
 realtime           | subscription_check_filters                | supabase_admin
 realtime           | to_regrole                                | supabase_admin
 realtime           | topic                                     | supabase_realtime_admin
 storage            | add_prefixes                              | supabase_storage_admin
 storage            | can_insert_object                         | supabase_storage_admin
 storage            | delete_leaf_prefixes                      | supabase_storage_admin
 storage            | delete_prefix                             | supabase_storage_admin
 storage            | delete_prefix_hierarchy_trigger           | supabase_storage_admin
 storage            | enforce_bucket_name_length                | supabase_storage_admin
 storage            | extension                                 | supabase_storage_admin
 storage            | filename                                  | supabase_storage_admin
 storage            | foldername                                | supabase_storage_admin
 storage            | get_level                                 | supabase_storage_admin
 storage            | get_prefix                                | supabase_storage_admin
 storage            | get_prefixes                              | supabase_storage_admin
 storage            | get_size_by_bucket                        | supabase_storage_admin
 storage            | list_multipart_uploads_with_delimiter     | supabase_storage_admin
 storage            | list_objects_with_delimiter               | supabase_storage_admin
 storage            | lock_top_prefixes                         | supabase_storage_admin
 storage            | objects_delete_cleanup                    | supabase_storage_admin
 storage            | objects_insert_prefix_trigger             | supabase_storage_admin
 storage            | objects_update_cleanup                    | supabase_storage_admin
 storage            | objects_update_level_trigger              | supabase_storage_admin
 storage            | objects_update_prefix_trigger             | supabase_storage_admin
 storage            | operation                                 | supabase_storage_admin
 storage            | prefixes_delete_cleanup                   | supabase_storage_admin
 storage            | prefixes_insert_trigger                   | supabase_storage_admin
 storage            | search                                    | supabase_storage_admin
 storage            | search_legacy_v1                          | supabase_storage_admin
 storage            | search_v1_optimised                       | supabase_storage_admin
 storage            | search_v2                                 | supabase_storage_admin
 storage            | update_updated_at_column                  | supabase_storage_admin
 supabase_functions | http_request                              | supabase_functions_admin
 vault              | _crypto_aead_det_decrypt                  | supabase_admin
 vault              | _crypto_aead_det_encrypt                  | supabase_admin
 vault              | _crypto_aead_det_noncegen                 | supabase_admin
 vault              | create_secret                             | supabase_admin
 vault              | update_secret                             | supabase_admin
(226 rows)

     schema_name     | has_usage 
---------------------+-----------
 Kitenga Schema      | t
 aotahi              | t
 auth                | t
 den_core            | t
 extensions          | t
 graphql             | t
 graphql_public      | t
 kitenga             | t
 manawa              | t
 merged              | t
 net                 | t
 pg_temp_14          | t
 pg_temp_15          | t
 pg_temp_17          | t
 pg_temp_20          | t
 pg_temp_24          | t
 pg_temp_26          | t
 pg_temp_29          | t
 pg_temp_35          | t
 pg_temp_38          | t
 pg_temp_39          | t
 pg_temp_45          | t
 pg_temp_50          | t
 pg_temp_52          | t
 pg_temp_57          | t
 pg_toast            | t
 pg_toast_temp_14    | t
 pg_toast_temp_15    | t
 pg_toast_temp_17    | t
 pg_toast_temp_20    | t
 pg_toast_temp_24    | t
 pg_toast_temp_26    | t
 pg_toast_temp_29    | t
 pg_toast_temp_35    | t
 pg_toast_temp_38    | t
 pg_toast_temp_39    | t
 pg_toast_temp_45    | t
 pg_toast_temp_50    | t
 pg_toast_temp_52    | t
 pg_toast_temp_57    | t
 pgbouncer           | t
 public              | t
 realtime            | t
 rongohia            | t
 rongokarere         | t
 storage             | t
 supabase_functions  | t
 supabase_migrations | t
 tiwhanawhana        | t
 vault               | t
 whiro               | t
(51 rows)














# Quick check both connect:
psql "$TEPUNA_URL" -c '\conninfo'
psql "$DEN_URL"    -c '\conninfo'
You are connected to database "postgres" as user "postgres" on host "db.ruqejtkudezadrqbdodx.supabase.co" (address "13.210.185.240") at port "5432".
SSL connection (protocol: TLSv1.3, cipher: TLS_AES_256_GCM_SHA384, compression: off, ALPN: postgresql)
psql: error: connection to server at "db.fyrzttjlvofmcfxibtpi.supabase.co" (34.199.60.90), port 5432 failed: FATAL:  password authentication failed for user "postgres"
connection to server at "db.fyrzttjlvofmcfxibtpi.supabase.co" (34.199.60.90), port 5432 failed: FATAL:  password authentication failed for user "postgres"
hemi-whiro@hemi-whiro-B150M-D3H:~$ 

