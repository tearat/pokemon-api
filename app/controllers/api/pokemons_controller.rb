class Api::PokemonsController < ApplicationController
  # acts_as_token_authentication_handler_for User

  def index
    limit  = params[:limit]  || 10
    offset = params[:offset] || 0

    @pokemons = Pokemon.limit(limit).offset(offset).all

    render json: {
      "total"    => Pokemon.all.size,
      "count"    => @pokemons.size,
      "offset"   => offset.to_i,
      "limit"    => limit.to_i,
      "pokemons" => @pokemons.map { |pokemon| PokemonsListSerializer.new(pokemon) }
    }
  end
end
