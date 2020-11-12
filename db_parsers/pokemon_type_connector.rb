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

db_types = $database.query("SELECT id, title FROM types").to_a

added_count = 0

pokemons.each do |pokemon|
  next if pokemon["types"].size == 0

  pokemon["types"].each do |type|
    type_object = db_types.select { |db_type| db_type["title"] == type }[0]
    # puts "Pokemon: #{pokemon['name']}"
    # puts "Type: #{type_object['title']}"
    type_id = type_object["id"]
    pokemon_id = pokemon["id"]
    is_exist = $database.query("SELECT type_id, pokemon_id FROM pokemon_type_relations WHERE type_id = '#{type_id}' AND pokemon_id = '#{pokemon_id}'").to_a
    if is_exist.size > 0
      # puts "Already exist".yellow
    else
      puts "INSERT INTO pokemon_type_relations (`type_id`, `pokemon_id`, `created_at`, `updated_at`) VALUES (#{type_id}, #{pokemon_id}, '2020-11-12 12:25:16.000000', '2020-11-12 12:25:16.000000')"
      $database.query("INSERT INTO pokemon_type_relations
        (`type_id`, `pokemon_id`, `created_at`, `updated_at`)
        VALUES
        (#{type_id}, #{pokemon_id}, '2020-11-12 12:25:16.000000', '2020-11-12 12:25:16.000000')")
      added_count += 1
    end
  end
end

puts "Pokemon type relations added: #{added_count}"
