class PokemonPageSerializer < ActiveModel::Serializer
  attributes :page, :total, :count, :offset, :limit, :pokemons

  def page
    @instance_options[:metadata][:page]
  end

  def total
    @instance_options[:metadata][:total]
  end

  def count
    @instance_options[:metadata][:count]
  end

  def offset
    @instance_options[:metadata][:offset]
  end

  def limit
    @instance_options[:metadata][:limit]
  end

  def pokemons
    self.object
  end

end
