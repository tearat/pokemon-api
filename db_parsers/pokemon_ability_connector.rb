require 'json'
require 'mysql2'
require 'dotenv/load'
require 'colorize'

$database = Mysql2::Client.new(
    :host     => 'localhost',
    :username => 'root',
    :password => 'root',
    :database => 'pokemon_dev',
)

pokemons = JSON.parse File.read 'pokemons.json'

db_abilities = $database.query("SELECT id, title FROM abilities").to_a

added_count = 0

pokemons.each do |pokemon|
  next if pokemon["abilities"].size == 0

  pokemon["abilities"].each do |ability|
    ability_object = db_abilities.select { |db_ability| db_ability["title"] == ability }[0]
    # puts "Pokemon: #{pokemon['name']}"
    # puts "Type: #{ability_object['title']}"
    ability_id = ability_object["id"]
    pokemon_id = pokemon["id"]
    is_exist = $database.query("SELECT ability_id, pokemon_id FROM pokemon_ability_relations WHERE ability_id = '#{ability_id}' AND pokemon_id = '#{pokemon_id}'").to_a
    if is_exist.size > 0
      # puts "Already exist".yellow
    else
      puts "INSERT INTO pokemon_ability_relations (`ability_id`, `pokemon_id`, `created_at`, `updated_at`) VALUES (#{ability_id}, #{pokemon_id}, '2020-11-12 12:25:16.000000', '2020-11-12 12:25:16.000000')"
      $database.query("INSERT INTO pokemon_ability_relations
        (`ability_id`, `pokemon_id`, `created_at`, `updated_at`)
        VALUES
        (#{ability_id}, #{pokemon_id}, '2020-11-12 12:25:16.000000', '2020-11-12 12:25:16.000000')")
      added_count += 1
    end
  end
end

puts "Pokemon ability relations added: #{added_count}"
