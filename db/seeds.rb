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
user2 = User.create!(email: 'aaa@arena.com', password: '123123', password_confirmation: '123123')
user3 = User.create!(email: 'ccc@arena.com', password: '123123', password_confirmation: '123123')
users = [user, user2, user3]

puts 'Creating heroes...'

CLASSES.each do |hero_class|
  users.each do |user_el|
    Creature.create!(name: "#{hero_class}-#{user_el.id}",
                     hero_class: hero_class,
                     atk: 5, def: 5, spd: 5, dex: 5, int: 5, luk: 5, max_hp: 5, hp: 5,
                     user_id: user_el.id)
  end
end
