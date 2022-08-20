class CreateBattles < ActiveRecord::Migration[7.0]
  def change
    create_table :battles do |t|
      t.references :player, null: false, foreign_key: { to_table: 'creatures' }
      t.references :enemy, null: false, foreign_key: { to_table: 'creatures' }
      t.boolean :victory

      t.timestamps
    end
  end
end
