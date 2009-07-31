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

    create_table :teams do |t|
      t.integer :conference_id
      t.string :ncaa_id
      t.string :ncaa_name
      t.float :ranking

      t.timestamps
    end

  end

  def self.down
    drop_table :conferences
    drop_table :divisions
    drop_table :teams
  end
end
