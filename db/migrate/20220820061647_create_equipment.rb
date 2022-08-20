class CreateEquipment < ActiveRecord::Migration[7.0]
  def change
    create_table :equipment do |t|
      t.references :creature, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.string :type

      t.timestamps
    end
  end
end
