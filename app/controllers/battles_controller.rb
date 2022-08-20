class BattlesController < ApplicationController
  def show
    @battle = Battle.find(params[:id])
    @player = @battle.player
    @enemy = @battle.enemy
  end

  def create
  end
end
