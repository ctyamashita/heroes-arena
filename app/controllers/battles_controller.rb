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
    if @player.hp.zero? || @enemy.hp.zero?
      @player.battles_count += 1
      @player.victories += 1 if @player.hp.positive?
      @player.save
      redirect_to creature_path(@player)
    else
      damages = turn_battle(@player, @enemy)
      @player_damage = damages[:player]
      @enemy_damage = damages[:enemy]
      redirect_to battle_path(@battle)
    end
  end

  private

  def player_params
    params.require(:player).permit(:action)
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
    @victory = @player.hp.positive?
    @victory = nil if @player.hp.positive? && @enemy.hp.positive?
    @battle.victory = @victory
    @battle.save
  end

  def creature_action(player, enemy)
    case player_params[:action]
    when 'attack' then attack_dmg(player, enemy)
    # when 'skill' then skill_dmg(player, enemy)
    else
      'Invalid action.'
    end
  end

  def attack_dmg(attacker, defender)
    if (attacker.dex - (defender.spd / 3)).positive?
      damage = attacker.atk - defender.def
      damage = 1 unless damage.positive?
      damage *= 5 if (attacker.luk) >= rand(100)
    else
      damage = 0
    end
    damage
  end

  def turn_battle(player, opponent)
    player_damage = creature_action(player, opponent)
    opponent_damage = attack_dmg(opponent, player)
    opponent.hp -= player_damage
    player.hp -= opponent_damage if opponent.hp.positive?
    player.hp = 0 if player.hp.negative?
    opponent.hp = 0 if opponent.hp.negative?
    player.save
    opponent.save
    { player: player_damage, enemy: opponent_damage }
  end
end
