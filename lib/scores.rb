#!/usr/bin/env ruby

require 'rubygems'
require 'active_support'
require 'hpricot'
require 'open-uri'

class Scores
  
  def initialize(date=Time.now)
    @date = date
    @home = {}
    @away = {}
  end
  
  def fetch
    with_final_games do |home, away|
      record_game(home, away)
    end
  end

  private

  def record_game(home, away)
    game = Game.new(:game_date => game_date)
    game.home_team = Team.find_or_create_by_name(home[:name])
    game.away_team = Team.find_or_create_by_name(away[:name])
    game.home_team_score = home[:score]
    game.away_team_score = away[:score]
    game.save
    puts(game.inspect)
  end

  # returns a date that is just the day, month, year
  def game_date
    Time.parse("#{@date.strftime("%m/%d/%Y")}")
  end

  def with_final_games
    with_containers do |container|
      if final?(container)
        determine_teams(container)
        determine_scores(container)
        yield @home, @away
      end
    end
    nil
  end
  
  def determine_scores(container)
    with_rhe_table(container) do |rhe_table|
      rows = rhe_table/"tr"
      @away[:score] = (rows[1]/"td").first.inner_html.to_i
      @home[:score] = (rows[2]/"td").first.inner_html.to_i
    end
  end
  
  def determine_teams(container)
    with_teams_table(container) do |teams_table|
      rows = teams_table/"tr"
      @away[:name] = (rows[1]/"td a").first.inner_html
      @home[:name] = (rows[2]/"td a").first.inner_html
    end
  end
  
  def final?(container)
    with_teams_table(container) do |table|
      rows = table/"tr"
      return true if (rows.first/"td").inner_html == "Final"
    end
  end
  
  def with_rhe_table(container)
    table = (container/"div.RHE table").first
    yield table
  end
  
  def with_teams_table(container)
    table = (container/"div.teams table").first
    yield table
  end
  
  def with_containers
    (doc/"div.gameContainer").each do |container|
      yield container
    end
  end
  
  def doc
    @doc ||= open(url) { |f| Hpricot(f) }
  end

  def url
    url = "http://sports.espn.go.com/mlb/scoreboard"
    url + "?date=#{@date.strftime("%Y%m%d")}"
  end
  
  def logger
    RAILS_DEFAULT_LOGGER
  end
  
end



