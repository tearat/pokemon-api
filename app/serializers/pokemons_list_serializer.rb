class PokemonsListSerializer < ActiveModel::Serializer
  attributes :name_clean, :abilities, :stats, :types, :img, :name,
             :base_experience, :height, :id, :is_default, :order, :weight

  def abilities
    relations = PokemonAbilityRelation.where(:pokemon_id => self.object.id).pluck(:ability_id)
    Ability.where(:id => relations).pluck :title
  end

  def stats
    {
      "hp": self.object.hp,
      "attack": self.object.attack,
      "defense": self.object.defense,
      "special-attack": self.object.special_attack,
      "special-defense": self.object.special_defense,
      "speed": self.object.speed,
    }
  end

  def types
    relations = PokemonTypeRelation.where(:pokemon_id => self.object.id).pluck(:type_id)
    Type.where(:id => relations).pluck :title
  end

  def order
    self.object.id
  end
end
