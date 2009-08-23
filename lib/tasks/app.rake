namespace :app do 
  namespace :games do 
    desc "Upload game records from NCAA"
    task :upload_ncaa do 
      Team.all.each do |team|
        puts team.ncaa_name
        schedule = NcaaSchedule.new(*team.ncaa_attributes_array)
        schedule.games.each do |ncaa_game|
          game = team.games.build(ncaa_game)
          next unless game.valid?
          game.save!
        end
        puts "#{schedule.games.length} -- #{team.reload.games.length}"
      end
    end

    task :copy_opponent_to_games do 
      games = Game.find(:all, :include => [:team, :opponent])
      games.each do |game|
        opponent = Team.find_by_ncaa_name(game.ncaa_opponent_name)
        game.opponent = opponent
        game.opponent_yaml_label = opponent.yaml_label unless opponent.nil?
        game.save!
      end
    end
  end
end
