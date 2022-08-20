class Creature < ApplicationRecord
  has_many :equipments, dependent: :destroy
  has_many :items, through: :equipments

  CLASSES = ['Necromancer', 'Warrior', 'Beastmaster', 'Ninja', 'Mage', 'Cleric', 'Ranger', 'Bard', 'Monk']
  ICONS = { 'Necromancer' => '💀',
            'Warrior' => '⚔️',
            'Beastmaster' => '🐾',
            'Ninja' => '🥷',
            'Mage' => '🪄',
            'Cleric' => '🩹',
            'Ranger' => '🏹',
            'Bard' => '🎶',
            'Monk' => '🙏' }

  COLORS = { 'Necromancer' => 'black',
            'Warrior' => '#B74742',
            'Beastmaster' => '#2A9250',
            'Ninja' => '#353F68',
            'Mage' => '#497BBE',
            'Cleric' => '#F35184',
            'Ranger' => '#81C451',
            'Bard' => '#8E57A2',
            'Monk' => '#F98C3C' }

  validates :name, uniqueness: true, presence: true
  validates :hero_class, inclusion: { in: CLASSES }

  def set_hp
    self.hp = (self.def / 3) * 5
    self.hp = 5 if self.def < 3
    self.max_hp = hp
  end

  def icon
    case hero_class
    when hero_class then ICONS[hero_class]
    else
      '❌'
    end
  end

  def default_image
    case hero_class
    when hero_class then "/assets/#{hero_class.downcase}.png"
    else
      ''
    end
  end

  def class_img
    case hero_class
    when hero_class then "/assets/#{hero_class.downcase}-icon.png"
    else
      ''
    end
  end

  def color
    case hero_class
    when hero_class then COLORS[hero_class]
    else
      ''
    end
  end
end
