-- to get table_schema, table_name, column_name and data_type
SELECT table_schema, table_name, column_name, data_type
FROM information_schema.columns
WHERE table_schema IN ('entries', 'marking', 'public', 'testlet')
ORDER BY table_schema, table_name, column_name
