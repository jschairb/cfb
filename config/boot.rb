require 'rubygems'
require 'logger'
require 'pathname'

APP_ROOT = "#{File.dirname(__FILE__)}/.." unless defined?(APP_ROOT)
ENV['APP_ENV'] ||= 'development'

module App

  class << self
    def boot!
      set_load_path
      initialize_database
      initialize_logger
    end

    protected
    def initialize_database
      require 'active_record'
      ActiveRecord::Base.configurations = YAML.load_file(APP_ROOT + '/config/database.yml')
      ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[ENV['APP_ENV']])
    end

    def initialize_logger
      logger = Logger.new $stderr
      logger.level = Logger::INFO
      ActiveRecord::Base.logger = logger
    end

    def set_load_path
      load_paths = %W( #{APP_ROOT}/vendor #{APP_ROOT}/lib )
      load_paths.reverse_each { |dir| $LOAD_PATH.unshift(dir) if File.directory?(dir) }

      Dir["#{APP_ROOT}/vendor/*"].each { |p| $LOAD_PATH << p }
      Dir["#{APP_ROOT}/vendor/*/lib"].each { |p| $LOAD_PATH << p }

      $LOAD_PATH.uniq!
    end
  end

end

App.boot!
