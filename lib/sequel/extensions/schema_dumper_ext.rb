require 'sequel/extensions/schema_dumper'
module Sequel
  module SchemaDumper
    alias_method :dump_table_schema_without_force, :dump_table_schema
    alias_method :dump_schema_migration_original, :dump_schema_migration
    alias_method :column_schema_to_ruby_type_without_uuid, :column_schema_to_ruby_type

    def dump_table_schema(table, opts=OPTS)
      dump_table_schema_without_force(table, opts).gsub('create_table(', 'create_table!(')
    end

    def dump_schema_migration(options=OPTS)
      dump_schema_migration_original(options).to_s.gsub(/^\s+$/, '')
    end

    def column_schema_to_ruby_type(schema)
      case schema[:db_type].downcase
      when 'uuid'
        { type: :uuid }
      when /char(?:acter)?\(36\)/
        { type: Suuid }
      else
        column_schema_to_ruby_type_without_uuid(schema)
      end
    end
  end
end
