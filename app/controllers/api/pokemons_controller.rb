class Api::PokemonsController < ApplicationController
  # acts_as_token_authentication_handler_for User

  def index
    page = params[:page] ? params[:page].to_i : 1
    limit = params[:limit] ? params[:limit].to_i : 10
    filter = params[:filter] || nil

    @pokemons = Pokemon.all
    total = @pokemons.size

    @pokemons = @pokemons.where("`name_clean` LIKE ?", "%#{filter}%") if filter
    found = @pokemons.size
    pages = (found.to_f / limit.to_f).ceil

    paginated = paginate @pokemons, per_page: limit
    count = paginated.size

    url = url_for controller: "pokemons", action: "index"
    next_page = (found - (limit * page)) > 0 ? "#{url}?page=#{page + 1}&limit=#{limit}&filter=#{filter}" : nil
    prev_page = (page > 1) ? "#{url}?page=#{page - 1}&limit=#{limit}&filter=#{filter}" : nil

    render json: {
      "total" => total,
      "found" => found,
      "limit" => limit,
      "count" => count,
      "pages" => pages,
      "current_page" => page,
      "next_page" => next_page,
      "prev_page" => prev_page,
      "pokemons" => paginated,
    }
  end
end
