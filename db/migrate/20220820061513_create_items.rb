class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :name
      t.integer :hp
      t.integer :atk
      t.integer :def
      t.integer :spd
      t.integer :dex
      t.integer :int
      t.integer :luk
      t.integer :price

      t.timestamps
    end
  end
end
