class CreateSpells < ActiveRecord::Migration[6.0]
  def change
    create_table :spells do |t|
      t.string :champion
      t.string :name
      t.string :cooldown
      t.string :cost
      t.string :key

      t.timestamps
    end
  end
end
