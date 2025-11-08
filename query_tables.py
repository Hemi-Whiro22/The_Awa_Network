#!/usr/bin/env python3
import psycopg2

try:
    conn = psycopg2.connect(
        host='ruqejtkudezadrqbdodx.supabase.co',
        port=5432,
        database='postgres',
        user='postgres',
        password='sb_secret_SO-_CLOqSy8R5Y0xGWiIzQ_b1ycYnkW'
    )
    
    cur = conn.cursor()
    cur.execute("""
        SELECT table_schema, table_name 
        FROM information_schema.tables 
        WHERE table_schema IN ('public', 'rsl')
        ORDER BY table_schema, table_name
    """)
    
    results = cur.fetchall()
    
    print("\n=== TABLES IN PUBLIC AND RSL SCHEMAS ===\n")
    current_schema = None
    for schema, table in results:
        if schema != current_schema:
            print(f"\n[{schema}]")
            current_schema = schema
        print(f"  - {table}")
    
    cur.close()
    conn.close()
    
except Exception as e:
    print(f"Error: {e}")
