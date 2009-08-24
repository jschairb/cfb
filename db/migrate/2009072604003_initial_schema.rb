class InitialSchema < ActiveRecord::Migration
  def self.up
    create_table :conferences do |t|
      t.string :name
      t.integer :division_id
      t.string :abbrev

      t.timestamps
    end

    create_table :divisions do |t|
      t.string :name
      t.string :abbrev
      t.float :point_value

      t.timestamps
    end

    create_table :games do |t|
      t.date    :date
      t.boolean :home
      t.string  :location
      t.string  :ncaa_opponent_name
      t.string  :ncaa_name
      t.boolean :neutral
      t.integer :opponent_id
      t.string  :result
      t.integer :score_opponent
      t.integer :score_team
      t.string  :note
      t.integer :team_id
      
      t.timestamps
    end

    create_table :teams do |t|
      t.integer :conference_id
      t.string :ncaa_id
      t.string :ncaa_name
      t.string :yaml_label

      t.timestamps
    end

    create_table :weeks do |t|
      t.string :season
      t.integer :number
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end

  def self.down
    drop_table :conferences
    drop_table :divisions
    drop_table :games
    drop_table :teams
    drop_table :weeks
  end
end
