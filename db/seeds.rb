# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
puts 'destroying old instances'
Battle.destroy_all
Creature.destroy_all
User.destroy_all

CLASSES = ['Necromancer', 'Warrior', 'Beastmaster', 'Ninja', 'Mage', 'Cleric', 'Ranger', 'Bard', 'Monk']

puts 'Creating users'
user = User.create!(email: 'cty@arena.com', password: '123123', password_confirmation: '123123')

puts 'Creating heroes...'

CLASSES.each_with_index do |hero_class, index|
  Creature.create!(name: "#{hero_class}-#{index}",
                   hero_class: hero_class,
                   atk: 5, def: 5, spd: 5, dex: 5, int: 5, luk: 5, max_hp: 5, hp: 5,
                   user_id: user.id)
  Creature.create!(name: "#{hero_class}-#{index + 1}",
                   hero_class: hero_class,
                   atk: 6, def: 3, spd: 6, dex: 5, int: 5, luk: 5, max_hp: 5, hp: 5,
                   user_id: user.id)
  Creature.create!(name: "#{hero_class}-#{index + 2}",
                   hero_class: hero_class,
                   atk: 4, def: 7, spd: 4, dex: 5, int: 1, luk: 9, max_hp: 10, hp: 10,
                   user_id: user.id)
end
