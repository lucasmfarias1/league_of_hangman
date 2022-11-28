class BeatSpell < ApplicationRecord
  belongs_to :spell
  belongs_to :player

  validates :spell_id, uniqueness: { scope: [:player_id] }
end
