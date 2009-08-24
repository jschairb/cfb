namespace :db do
  task :test_boot do 
    puts ENV['APP_ENV']
    puts ActiveRecord::Base.configurations[ENV['APP_ENV']]
  end

  desc 'Create the database defined in config/database.yml'
  task :create do
    create_database(ActiveRecord::Base.configurations[ENV['APP_ENV']])
  end

  desc "Regenerate db from migrations, clone structure to test env, and reload dev fixtures"
  task :do_over => %w[db:drop db:create db:migrate db:fixtures:load]

  task :drop do 
    begin
      drop_database(ActiveRecord::Base.configurations[ENV['APP_ENV']])
    rescue Exception => e
      puts "Couldn't drop #{ENV['APP_ENV']['database']} : #{e.inspect}"
    end
  end

  namespace :fixtures do
    desc 'Dump database data to fixtures.'
    task :dump do
      sql  = "SELECT * FROM %s"
      skip_tables = ["schema_info", "schema_migrations", "divisions", "conferences", "teams", "weeks"]
      (ActiveRecord::Base.connection.tables - skip_tables).each do |table_name|
        i = "000"
        File.open("#{APP_ROOT}/db/data/#{table_name}.yml", 'w') do |file|
          puts table_name
          data = ActiveRecord::Base.connection.select_all(sql % table_name)
          file.write data.inject({}) { |hash, record|
            hash["#{table_name}_#{i.succ!}"] = sanitize_record(record, table_name) 
            hash
          }.to_yaml
        end
      end
    end

    def sanitize_record(record, table_name)
      %w(id created_at updated_at).each do |col|
        record.delete(col)
      end
      record["team"] = Team.find(record["team_id"]).yaml_label unless record["team_id"].nil?
      record["opponent"] = Team.find(record["opponent_id"]).yaml_label unless record["opponent_id"].nil?
      week = Week.find(record["week_id"]) if record["week_id"]
      record["week"] = "weeks_#{week.number}" if week
      if table_name == "games"
        %w(team_id opponent_id week_id).each do |col|
          record.delete(col)
        end
      end
      record.merge("<<" => "*DEFAULTS")
    end

    desc 'Load data from fixtures. Uses development database.'
    task :load do 
      require 'active_record/fixtures'
      class Division < ActiveRecord::Base; has_many :conferences; end
      class Conference < ActiveRecord::Base; belongs_to :division; has_many :teams; end
      class Team < ActiveRecord::Base; belongs_to :conference; has_many :games; end
      class Game < ActiveRecord::Base; belongs_to :team; end

      (ENV['FIXTURES'] ? ENV['FIXTURES'].split(/,/) : Dir.glob(File.join(APP_ROOT, 'db', 'data', '*.{yml,csv}'))).each do |fixture_file|
        Fixtures.create_fixtures('db/data', File.basename(fixture_file, '.*'))
      end
    end
  end
  
  desc "Migrate the database. Opts: VERSION=x. VERBOSE=false."
  task :migrate do
    require 'migration_helpers/init'
    ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
    ActiveRecord::Migrator.migrate(APP_ROOT + "/db/migrate/", ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
    Rake::Task[ "db:schema:dump" ].execute
  end

  namespace :schema do
    desc "Create schema.rb file that can be portably used against any DB supported by AR"
    task :dump do
      require 'active_record/schema_dumper'
      File.open(ENV['SCHEMA'] || APP_ROOT + "/db/schema.rb", "w") do |file|
        ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
      end
    end

    desc "Load a ar_schema.rb file into the database"
    task :load do
      file = ENV['SCHEMA'] || APP_ROOT + "/db/schema.rb"
      load(file)
    end
  end

  desc "Create a new migration"
  task :new_migration do |t|
    unless ENV['name']
      puts "Error: must provide name of migration to generate."
      puts "For example: rake #{t.name} name=add_field_to_form"
      exit 1
    end

    underscore = lambda { |camel_cased_word|
      camel_cased_word.to_s.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
    }

    migration  = underscore.call( ENV['name'] )
    file_name  = "db/migrate/#{Time.now.utc.strftime('%Y%m%d%H%M%S')}_#{migration}.rb"
    class_name = migration.split('_').map { |s| s.capitalize }.join

    file_contents = <<eof
class #{class_name} < ActiveRecord::Migration
  def self.up
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
eof
    File.open(file_name, 'w') { |f| f.write file_contents }

    puts "Created migration #{file_name}"
  end
end

def create_database(config)
  `touch "#{config['database']}"`
end

def drop_database(config)
  FileUtils.rm(File.join(APP_ROOT, config['database']))
end
