class AddUserIdToCreature < ActiveRecord::Migration[7.0]
  def change
    add_reference :creatures, :user, null: false, foreign_key: true
  end
end
