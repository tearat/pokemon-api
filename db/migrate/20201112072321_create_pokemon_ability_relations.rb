class CreatePokemonAbilityRelations < ActiveRecord::Migration[6.0]
  def change
    create_table :pokemon_ability_relations do |t|
      t.belongs_to :pokemon, null: false, foreign_key: true
      t.belongs_to :ability, null: false, foreign_key: true

      t.timestamps
    end
  end
end
