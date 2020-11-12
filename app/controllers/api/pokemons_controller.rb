class Api::PokemonsController < ApplicationController
  # acts_as_token_authentication_handler_for User

  def index
    limit  = params[:limit]  ? params[:limit].to_i  : 10
    offset = params[:offset] ? params[:offset].to_i : 0
    filter = params[:filter] || nil

    if filter
      @pokemons = Pokemon.where("`name_clean` LIKE ?", "%#{filter}%").limit(limit).offset(offset).all
    else
      @pokemons = Pokemon.limit(limit).offset(offset).all
    end

    total = Pokemon.all.size

    is_next_page = (total - offset) >= limit
    next_params = {
      :limit => limit,
      :offset => offset + limit,
      :filter => filter,
    }.map { |key, value| "#{key}=#{value}" }.join "&"
    next_page = is_next_page ? "http://localhost:3000/api/pokemons?#{next_params}" : nil

    is_prev_page = offset > 0
    prev_offset = (offset - limit) >= 0 ? offset - limit : 0
    prev_params = {
      :limit => limit,
      :offset => prev_offset,
      :filter => filter,
    }.map { |key, value| "#{key}=#{value}" }.join "&"
    prev_page = is_prev_page ? "http://localhost:3000/api/pokemons?#{prev_params}" : nil

    render json: {
      "total"     => total,
      "count"     => @pokemons.size,
      "offset"    => offset.to_i,
      "limit"     => limit.to_i,
      "next_page" => next_page,
      "prev_page" => prev_page,
      "pokemons"  => @pokemons.map { |pokemon| PokemonsListSerializer.new(pokemon) }
    }
  end
end
