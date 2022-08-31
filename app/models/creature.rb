class Creature < ApplicationRecord
  has_many :battles, foreign_key: :player_id
  has_many :equipments, dependent: :destroy
  has_many :items, through: :equipments
  has_many :enemies, through: :battles

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
  validate :attr_total_points

  def attr_total_points
    points_added = self.atk + self.def + self.spd + self.dex + self.int + self.luk
    errors.add(:hero_class, "You need to spend all your points.") if points_added != 30
  end

  def hp_display
    hp_lost = self.max_hp - self.hp
    hp = ('♥️' * self.hp).chars
    hp.values_at(* hp.each_index.select(&:even?)).join + ('🤍' * hp_lost)
  end

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

  def banner
    case hero_class
    when hero_class then "/assets/#{hero_class.downcase}-banner.png"
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

  def action(target, action)
    case action
    when 'atk' then calculate_atk_dmg(target)
    # when 'skill' then skill_dmg(self, target)
    else
      'Invalid action.'
    end
  end

  def calculate_atk_dmg(defender)
    hit_chance = accuracy(defender)
    if hit_chance >= rand(100)
      damage = on_hit_damage(defender)
    else
      damage = 0
    end
    dmg_chance = (self.atk - (defender.def / 3)).positive? ? self.atk - (defender.def / 3) : 1
    { dmg: damage, dmg_chance: dmg_chance, hit: hit_chance, crit: self.luk.fdiv(100) * 100 }
  end

  def on_hit_damage(defender)
    crit = (self.luk) >= rand(100)
    damage = self.atk - (defender.def / 3)
    damage = 1 unless damage.positive?
    damage *= 5 if crit
    damage
  end

  def accuracy(defender)
    diff = self.dex - defender.spd
    diff = 1 if diff.positive?
    diff = -8.5 if diff < -9
    hit_chance = 90 + (10 * diff)
    hit_chance = 0 if hit_chance.negative?
    hit_chance
  end
end
