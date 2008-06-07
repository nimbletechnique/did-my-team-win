class ResultsController < ApplicationController
  
  before_filter :ensure_team, :except => [:select_team, :reset_team]
  before_filter :load_team
  before_filter :set_title
  
  def index
    @games = Game.find_recent_for_team(@team)
    @game = @games.first if @games.first.game_date >= 2.days.ago.beginning_of_day 
  end
  
  def select_team
    if request.post?
      team = Team.find(params[:team])
      
      cookies[:team] = { :value => "#{team.id}", :expires => 365.days.from_now }
      redirect_to :action => "index" and return
    end
  end

  def reset_team
    cookies[:team] = nil
    redirect_to :action => "index"
  end

  private
  
  def load_team
    @team = Team.find(cookies[:team]) unless cookies[:team].blank?
  end
  
  def ensure_team
    if cookies[:team].blank?
      redirect_to :action => "select_team" and return
    end
  end

  def set_title
    @title = "Did #{@team.name} win today?" if @team
  end
  

end
