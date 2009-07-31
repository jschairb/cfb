require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rubygems'
require 'activerecord'

require 'lib/division'
require 'lib/conference'

# require 'pp'
# require 'rubygems'
# require 'hpricot'
# require 'open-uri'

# doc = Hpricot(open('http://www.jhowell.net/cf/scores/OhioState.htm'))

# def header(row)
#   (row/"td/p/a").each do |header|
#     puts header.inner_html
#   end
# end

# def games(table)
# end

# (doc/"table[2]").each do |table|
#   puts "+++++++++++++++++++++++++++++"
#   (table/"tr[1]").each do |row|
#     header(row)
#   end
#   puts (table/"tr[2]")
# end

# class Game
#   def conference_points
#   end

#   def division_points
#   end

#   def location_points
#   end
# end

# class Team

#   def games
#     @games = []
#     5.times do 
#       @games << Game.new
#     end
#     return @games
#   end

# end

# @team = Team.new

# puts @team.games.inspect
