class BattlesController < ApplicationController
  before_action :setting_battle, only: :create
  before_action :battle_results, only: :update

  def create
    if @battle.save
      redirect_to battle_path(@battle)
    else
      @errors = @battle.errors[:player][0]
      redirect_to creature_path(@player, empty: true) unless @enemy
    end
  end

  def show
    @battle = Battle.find(params[:id])
    @player = @battle.player
    @enemy = @battle.enemy
    chances = @player.calculate_atk_dmg(@enemy)
    @hit = chances[:hit]
    @crit = chances[:crit]
    @dmg = chances[:dmg_chance]
    @animation = @battle.animation(params)
    # redirect_to creature_path(@player) if @player.hp.zero? || @enemy.hp.zero?
  end

  def update
    if @player.hp.zero? || @enemy.hp.zero?
      update_player(@player)
      @battle.save
      redirect_to creature_path(@player)
    else
      @battle.turn += 1
      @battle.save
      res = @battle.turn_battle(p_params[:act]) # turn results
      redirect_to battle_path(@battle, p_act: p_params[:act], p_dmg: res[:p], e_act: res[:e_act], e_dmg: res[:e])
    end
  end

  private

  def p_params
    params.require(:player).permit(:act)
  end

  def setting_battle
    @player = Creature.find(params[:creature_id])
    if @player.battles.select { |battle| battle.victory.nil? }.any?
      @battle = @player.battles.first
    else
      @enemy = find_enemy(@player)
      @battle = Battle.new
      @battle.player = @player
      @battle.enemy = @enemy
    end
  end

  def battle_results
    @battle = Battle.find(params[:id])
    @player = @battle.player
    @enemy = @battle.enemy
    @victory = @player.hp.positive?
    @victory = nil if @player.hp.positive? && @enemy.hp.positive?
    @battle.victory = @victory
  end

  def update_player(player)
    player.battles_count += 1
    player.victories += 1 if player.hp.positive?
    player.save
  end

  def find_enemy(player)
    Creature.all.length.times do
      @enemy = Creature.where.not(hp: 0).reject { |creature| creature == player }.sample
      break if @enemy.nil? || @enemy.battles.empty?
    end
    @enemy
  end
end
