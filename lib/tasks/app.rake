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

    task :copy_weeks_to_games do 
      Game.all.each do |game|
        week = Week.find(:first, 
          :conditions => ["weeks.start_date < ? AND weeks.end_date > ?", game.date, game.date])
        game.week = week
        game.save!
      end
    end
  end
  namespace :ratings do 
    desc "creates ratings for all weeks"
    task :compute do 
      Rating.compute()
    end
  end
end
