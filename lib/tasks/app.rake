namespace :app do 
  namespace :games do 
    desc "Upload game records from NCAA"
    task :upload_ncaa do 
      Team.all.each do |team|
        puts team.ncaa_name
        schedule = NcaaSchedule.new(*team.ncaa_attributes_array)
        schedule.games.each do |ncaa_game|
          game = team.games.build(ncaa_game)
          opponent = Team.find_by_ncaa_name(ncaa_game[:opponent])
          if opponent
            game.opponent_id = opponent.id
          else
            game.note = ncaa_game[:opponent]
          end
          next unless game.valid?
          game.save!
        end
        puts "#{schedule.games.length} -- #{team.reload.games.length}"
      end
    end
  end
end
