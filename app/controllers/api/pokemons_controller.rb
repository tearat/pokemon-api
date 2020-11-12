class Api::PokemonsController < ApplicationController
  # acts_as_token_authentication_handler_for User

  def index
    @pokemons = Pokemon
    @pokemons = @pokemons.limit(params[:limit])   if params[:limit]
    @pokemons = @pokemons.offset(params[:offset]) if params[:offset]
    @pokemons = @pokemons.all

    render json: {
      "total"    => Pokemon.all.size,
      "count"    => @pokemons.size,
      "offset"   => params[:offset].to_i || 0,
      "limit"    => params[:limit].to_i  || 10,
      "pokemons" => @pokemons.map { |pokemon| PokemonsListSerializer.new(pokemon) }
    }
  end
end
