class CreateBeatSpells < ActiveRecord::Migration[6.0]
  def change
    create_table :beat_spells do |t|
      t.references :spell, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true

      t.timestamps
    end
  end
end
