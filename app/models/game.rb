class Game < ActiveRecord::Base
  belongs_to :home_team, :class_name => "Team", :foreign_key => :home_team_id
  belongs_to :away_team, :class_name => "Team", :foreign_key => :away_team_id
  
  validates_presence_of :home_team
  validates_presence_of :away_team
  validates_presence_of :game_date
  
  def self.find_recent_for_team(team)
    self.find(:all, :limit => 6, 
              :order => 'game_date DESC',
              :include => [:home_team, :away_team], 
              :conditions => ["teams.name = ? or away_teams_games.name = ?", team.name, team.name])
  end
  
  def validate
    if home_team 
      if Game.find(:first, 
                   :include => [:home_team], 
                   :conditions => ["game_date = ? and teams.name = ?", game_date, home_team.name])
        errors.add(:home_team, "Already has a game for this date")
      end
    end
    if away_team 
      if Game.find(:first, 
                   :include => [:away_team], 
                   :conditions => ["game_date = ? and teams.name = ?", game_date, away_team.name])
        errors.add(:home_team, "Already has a game for this date")
      end
    end
  end
end
