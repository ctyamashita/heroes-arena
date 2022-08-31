class Battle < ApplicationRecord
  belongs_to :player, class_name: 'Creature', foreign_key: :player_id
  belongs_to :enemy, class_name: 'Creature', foreign_key: :enemy_id

  # validate :player_alive, :enemy_alive

  # def player_alive
  #   errors.add(:player, "Your hero need to rest.") unless player.hp.positive?
  # end

  # def enemy_alive
  #   errors.add(:enemy, "Your opponent can't fight.") unless enemy.hp.positive?
  # end

  def animation(params)
    both_atk = params[:p_act] == 'atk' && params[:e_act] == 'atk'
    animation = two_atk_animations(params) if both_atk
    animation = 'atk-player' if self.enemy.hp.zero?
    animation
  end

  def two_atk_animations(params)
    # both attack and both miss
    css_class = 'atk-animation'
    player_miss = params[:p_dmg].to_i.zero? && params[:e_dmg].to_i.positive?
    # both attack and player suffers damage
    css_class = 'atk-player-hit-animation' if player_miss
    # both attack and enemy suffers damage
    enemy_miss = params[:e_dmg].to_i.zero? && params[:p_dmg].to_i.positive?
    css_class = 'atk-enemy-hit-animation' if enemy_miss
    # both attack and both suffer damage
    both_hit = params[:e_dmg].to_i.positive? && params[:p_dmg].to_i.positive?
    css_class = 'atk-hit-animation' if both_hit
    css_class
  end

  def turn_battle(p_action)
    player_chances = self.player.action(self.enemy, p_action)
    player_damage = player_chances[:dmg]
    e_action = ['atk'].sample
    opponent_chances = self.enemy.action(player, e_action)
    opponent_damage = opponent_chances[:dmg]
    battle_resolve(player_damage, opponent_damage, e_action)
  end

  def battle_resolve(player_dmg, opponent_dmg, e_action)
    self.enemy.hp -= player_dmg
    self.player.hp -= opponent_dmg if self.enemy.hp.positive?
    self.player.hp = 0 if self.player.hp.negative?
    self.enemy.hp = 0 if self.enemy.hp.negative?
    self.player.save
    self.enemy.save
    { p: player_dmg, e: opponent_dmg, e_act: e_action }
  end
end
