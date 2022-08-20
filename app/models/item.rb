class Item < ApplicationRecord
  has_many :equipments
  has_many :creatures, through: :equipments

  validates :name, presence: true, uniqueness: true
  validates :hp, presence: true, numericality: true
  validates :atk, presence: true, numericality: true
  validates :def, presence: true, numericality: true
  validates :spd, presence: true, numericality: true
  validates :dex, presence: true, numericality: true
  validates :int, presence: true, numericality: true
  validates :luk, presence: true, numericality: true
end
