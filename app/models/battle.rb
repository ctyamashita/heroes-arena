class Battle < ApplicationRecord
  belongs_to :player
  belongs_to :enemy
end
