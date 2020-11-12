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

added_pokemons = $database.query("SELECT name FROM pokemons").to_a.map { |item| item["name"] }

added_count = 0

pokemons.each do |pokemon|
  next if added_pokemons.include? pokemon["name"]
  # p pokemon

  sql = "INSERT INTO pokemons (
    `id`,
    `name_clean`,
    `hp`,
    `attack`,
    `defense`,
    `special_attack`,
    `special_defense`,
    `speed`,
    `img`,
    `name`,
    `base_experience`,
    `height`,
    `weight`,
    `is_default`,
    `order`,
    `created_at`,
    `updated_at`
  ) VALUES
  (
    '#{pokemon["id"]}',
    '#{pokemon["name_clean"]}',
    '#{pokemon["stats"].size > 0 ? pokemon["stats"]["hp"] : 1}',
    '#{pokemon["stats"].size > 0 ? pokemon["stats"]["attack"] : 1}',
    '#{pokemon["stats"].size > 0 ? pokemon["stats"]["defense"] : 1}',
    '#{pokemon["stats"].size > 0 ? pokemon["stats"]["special-attack"] : 1}',
    '#{pokemon["stats"].size > 0 ? pokemon["stats"]["special-defense"] : 1}',
    '#{pokemon["stats"].size > 0 ? pokemon["stats"]["speed"] : 1}',
    '#{pokemon["img"]}',
    '#{pokemon["name"]}',
    '#{pokemon["base_experience"] || 0}',
    '#{pokemon["height"]}',
    '#{pokemon["weight"]}',
    '#{pokemon["is_default"] ? 1 : 0}',
    '#{pokemon["order"]}',
    '2020-11-12 12:25:16.000000',
    '2020-11-12 12:25:16.000000'
  )"
  puts sql
  $database.query(sql)
  puts "Сохранено!".green
  added_count += 1
end

puts "Pokemons added: #{added_count}"
