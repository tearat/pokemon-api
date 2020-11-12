class PokemonAbilityRelation < ApplicationRecord
  belongs_to :pokemon
  belongs_to :ability
end
