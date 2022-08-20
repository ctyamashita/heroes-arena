class Equipment < ApplicationRecord
  belongs_to :creature
  belongs_to :item
end
