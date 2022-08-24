class AddBattlesCountToCreatures < ActiveRecord::Migration[7.0]
  def change
    add_column :creatures, :battles_count, :integer, default: 0
    add_column :creatures, :victories, :integer, default: 0
  end
end
