class BattlesController < ApplicationController
  def create
    @player = Creature.find(params[:creature_id])
    @enemy = Creature.where.not(id: @player, hp: 0).sample
    @battle = Battle.new
    @battle.player = @player
    @battle.enemy = @enemy
    @battle.save
    redirect_to edit_creature_battle_creature_path(@player, @battle, @enemy)
  end
end
