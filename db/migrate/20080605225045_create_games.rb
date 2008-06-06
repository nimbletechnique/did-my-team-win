class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.datetime :game_date
      t.integer :home_team_id
      t.integer :home_team_score
      t.integer :away_team_id
      t.integer :away_team_score
      t.timestamps
    end
  end

  def self.down
    drop_table :games
  end
end
