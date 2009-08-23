require 'rake'
require 'active_support'

require(File.join(File.dirname(__FILE__), 'config', 'boot'))
require 'cfb'

Dir["#{APP_ROOT}/**/tasks/*.rake"].each { |ext| load ext }

task :default => :spec
