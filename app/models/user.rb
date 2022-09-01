class User < ApplicationRecord
  has_many :creatures
  has_many :battles, through: :creatures
end
