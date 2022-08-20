class CreateCreatures < ActiveRecord::Migration[7.0]
  def change
    create_table :creatures do |t|
      t.string :name
      t.boolean :dead, default: false
      t.integer :lvl, default: 1
      t.integer :max_hp
      t.integer :hp
      t.integer :atk
      t.integer :def
      t.integer :spd
      t.integer :dex
      t.integer :int
      t.integer :luk
      t.integer :exp, default: 0
      t.string :hero_class

      t.timestamps
    end
  end
end
