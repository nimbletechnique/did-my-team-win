module ResultsHelper

  def game_time(game)
    game.game_date.strftime("%b %d %Y")
  end
  
  def game_teams(game)
    game.away_team.name + " (#{game.away_team_score})" + " @ " + game.home_team.name + " (#{game.home_team_score})"
  end

  def win?(game)
    return unless game
    us, them = game.home_team_score, game.away_team_score
    if game.away_team.name == @team.name
      us, them = them, us
    end
    us > them
  end
  
  def teams_for_select
    @teams_for_select ||= Team.find(:all, :order => "name").map { |t| [t.name, t.id] }
  end

end
