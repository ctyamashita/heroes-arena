class BattlesController < ApplicationController
  def create
    @player = Creature.find(params[:creature_id])
    @enemy = Creature.where.not(id: @player, hp: 0).sample
    @battle = Battle.new
    @battle.player = @player
    @battle.enemy = @enemy
    if @battle.save
      redirect_to battle_path(@battle)
    else
      @errors = @battle.errors
      render "creatures/show"
    end
  end

  def show
    @battle = Battle.find(params[:id])
    @player = @battle.player
    @enemy = @battle.enemy
  end

  def update
    @battle = Battle.find(params[:id])
    @player = @battle.player
    @enemy = @battle.enemy
    @player.hp -= player_params[:hp].to_i
    @player.hp = 0 if @player.hp.negative?
    @enemy.hp -= player_params[:hp].to_i
    @enemy.hp = 0 if @enemy.hp.negative?

    @victory = @player.hp.positive?
    @victory = nil if @player.hp.positive? && @enemy.hp.positive?
    @battle.victory = @victory

    @player.save
    @enemy.save
    @battle.save
    if @player.hp == 0 || @enemy.hp == 0
      redirect_to creature_path(@player)
    else
      redirect_to battle_path(@battle)
    end
  end

  private

  def player_params
    params.require(:player).permit(:hp)
  end

  def enemy_params
    params.require(:enemy).permit(:hp)
  end
end
