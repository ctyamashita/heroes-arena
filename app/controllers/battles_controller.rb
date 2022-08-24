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
    @battle = Battle.find(params[:id])
    @player = @battle.player
    @enemy = @battle.enemy
    @battle.save
    if @player.hp.zero? || @enemy.hp.zero?
      @player.battle_count += 1
      @player.save
      redirect_to creature_path(@player)
    else
      @player_damage = creature_action(@player, @enemy)
      @enemy_damage = attack_dmg(@enemy, @player)
      @player.save
      @enemy.save
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
    @player.hp = 0 if @player.hp.negative?
    @enemy.hp = 0 if @enemy.hp.negative?

    @victory = @player.hp.positive?
    @victory = nil if @player.hp.positive? && @enemy.hp.positive?
    @battle.victory = @victory
  end

  def creature_action(player, enemy)
    case player_params[:action]
    when 'attack' then attack_dmg(player, enemy)
    # when 'skill' then skill_dmg(player, enemy)
    else
      'Invalid action.'
    end
  end

  def attack_dmg(player, target)
    if (player.dex - target.spd).positive?
      damage = target.def - player.atk
      damage = 1 unless damage.positive?
      damage *= 5 if (player.luk) >= rand(100)
    else
      damage = 0
    end
    damage
  end
end
