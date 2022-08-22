class Battle < ApplicationRecord
  belongs_to :player, class_name: 'Creature', foreign_key: :player_id
  belongs_to :enemy, class_name: 'Creature', foreign_key: :enemy_id

  validate :player_alive, :enemy_alive

  def player_alive
    errors.add(:player, "Your hero need to rest.") unless player.hp.positive?
  end

  def enemy_alive
    errors.add(:enemy, "Your opponent can't fight.") unless enemy.hp.positive?
  end
end
