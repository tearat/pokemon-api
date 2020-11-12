class CreatePokemons < ActiveRecord::Migration[6.0]
  def change
    create_table :pokemons do |t|
      t.string :name_clean

      # stats
      t.integer :hp
      t.integer :attack
      t.integer :defense
      t.integer :special_attack
      t.integer :special_defense
      t.integer :speed

      t.string :img
      t.string :name

      t.integer :base_experience
      t.integer :height
      t.integer :weight

      t.boolean :is_default

      t.timestamps
    end
  end
end
