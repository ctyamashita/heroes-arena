class BattlesController < ApplicationController
  before_action :setting_battle, only: :create
  before_action :battle_results, only: :update
  before_action :battle_animation, only: :show

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
    @player_hp = hp_display(@player)
    @enemy_hp = hp_display(@enemy)
    chances = calculate_atk_dmg(@player, @enemy)
    @hit = chances[:hit]
    @crit = chances[:crit]
    @dmg = chances[:dmg_chance]
    @animation = 'atk-player' if @enemy.hp.zero?
    # redirect_to creature_path(@player) if @player.hp.zero? || @enemy.hp.zero?
  end

  def update
    if @player.hp.zero? || @enemy.hp.zero?
      update_player(@player)
      redirect_to creature_path(@player)
    else
      res = turn_battle(@player, @enemy, p_params[:act]) # turn results
      redirect_to battle_path(@battle, p_act: p_params[:act], p_dmg: res[:p], e_act: res[:e_act], e_dmg: res[:e])
    end
  end

  private

  def p_params
    params.require(:player).permit(:act)
  end

  def hp_display(creature)
    hp_lost = creature.max_hp - creature.hp
    @hp = ('♥️' * creature.hp).chars
    @hp = @hp.values_at(* @hp.each_index.select(&:even?)).join + ('🤍' * hp_lost)
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
    @battle.save
  end

  def creature_action(player, enemy, action)
    case action
    when 'atk' then calculate_atk_dmg(player, enemy)
    # when 'skill' then skill_dmg(player, enemy)
    else
      'Invalid action.'
    end
  end

  def calculate_atk_dmg(attacker, defender)
    diff = attacker.dex - defender.spd
    diff = 1 if diff.positive?
    diff = -8.5 if diff < -9
    hit_chance = 90 + (10 * diff)
    hit_chance = 0 if hit_chance.negative?
    crit = (attacker.luk) >= rand(100)
    if hit_chance >= rand(100)
      damage = attacker.atk - (defender.def / 3)
      damage = 1 unless damage.positive?
      damage *= 5 if crit
    else
      damage = 0
    end
    dmg_chance = (attacker.atk - (defender.def / 3)).positive? ? attacker.atk - (defender.def / 3) : 1
    { dmg: damage, dmg_chance: dmg_chance, hit: hit_chance, crit: attacker.luk.fdiv(100) * 100 }
  end

  def turn_battle(player, opponent, p_action)
    player_chances = creature_action(player, opponent, p_action)
    player_damage = player_chances[:dmg]
    e_action = ['atk'].sample
    opponent_chances = creature_action(opponent, player, e_action)
    opponent_damage = opponent_chances[:dmg]
    opponent.hp -= player_damage
    player.hp -= opponent_damage if opponent.hp.positive?
    player.hp = 0 if player.hp.negative?
    opponent.hp = 0 if opponent.hp.negative?
    player.save
    opponent.save
    { p: player_damage, e: opponent_damage, e_act: e_action }
  end

  def battle_animation
    both_atk = params[:p_act] == 'atk' && params[:e_act] == 'atk'
    if both_atk
      # both attack and both miss
      @animation = 'atk-animation'
      player_miss = params[:p_dmg].to_i.zero? && params[:e_dmg].to_i.positive?
      # both attack and player suffers damage
      @animation = 'atk-player-hit-animation' if player_miss
      # both attack and enemy suffers damage
      enemy_miss = params[:e_dmg].to_i.zero? && params[:p_dmg].to_i.positive?
      @animation = 'atk-enemy-hit-animation' if enemy_miss
      # both attack and both suffer damage
      both_hit = params[:e_dmg].to_i.positive? && params[:p_dmg].to_i.positive?
      @animation = 'atk-hit-animation' if both_hit
    end
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
