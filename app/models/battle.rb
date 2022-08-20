class Battle < ApplicationRecord
  belongs_to :player, class_name: 'Creature', foreign_key: :player_id
  belongs_to :enemy, class_name: 'Creature', foreign_key: :enemy_id
  # belongs_to :alpha, :class_name => 'Plan', :foreign_key => 'plan'
end
