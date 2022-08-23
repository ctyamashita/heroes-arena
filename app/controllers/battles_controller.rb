class BattlesController < ApplicationController
  before_action :setting_battle, only: :create
  before_action :battle_results, only: :update

  def create
    if @battle.save
      redirect_to battle_path(@battle)
    else
      @errors = @battle.errors[:player][0]
      render "creatures/show", status: :unprocessable_entity
    end
  end

  def show
    @battle = Battle.find(params[:id])
    @player = @battle.player
    @enemy = @battle.enemy
    @player_hp = hp_display(@player)
    @enemy_hp = hp_display(@enemy)
  end

  def update
    @player.save
    @enemy.save
    @battle.save
    if @player.hp.zero? || @enemy.hp.zero?
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

  def hp_display(creature)
    hp_lost = creature.max_hp - creature.hp
    @hp = ('♥️' * creature.hp).chars
    @hp = @hp.values_at(* @hp.each_index.select(&:even?)).join + ('🤍' * hp_lost)
  end

  def setting_battle
    @player = Creature.find(params[:creature_id])
    @enemy = Creature.where.not(name: @player.name, hp: 0).sample
    @battle = Battle.new
    @battle.player = @player
    @battle.enemy = @enemy
  end

  def battle_results
    @battle = Battle.find(params[:id])
    @player = @battle.player
    @enemy = @battle.enemy
    @player.hp -= player_params[:hp].to_i
    @player.hp = 0 if @player.hp.negative?
    @enemy.hp -= enemy_params[:hp].to_i
    @enemy.hp = 0 if @enemy.hp.negative?

    @victory = @player.hp.positive?
    @victory = nil if @player.hp.positive? && @enemy.hp.positive?
    @battle.victory = @victory
  end
end
