require(File.join(File.dirname(__FILE__), 'config', 'boot'))

#http://www.jbarnette.com/2009/08/27/on-rake.html

require 'rubygems'
require 'activerecord'

require 'lib/division'
require 'lib/conference'
require 'lib/ncaa_schedule'
require 'lib/team'
require 'lib/game'
require 'lib/rating'
require 'lib/week'

require 'lib/web_team'
require 'lib/web_team_list'
