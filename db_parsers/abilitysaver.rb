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
abilities = pokemons.map { |pokemon| pokemon["abilities"] }

# p abilities

abilities_unique = []

abilities.each do |ability_block|
  ability_block.each do |ability|
    abilities_unique << ability unless abilities_unique.include? ability
  end
end

added_abilities = $database.query("SELECT title FROM abilities").to_a.map { |item| item["title"] }

added_count = 0

abilities_unique.each do |ability|
  next if added_abilities.include? ability

  sql = "INSERT INTO abilities (
    `title`,
    `created_at`,
    `updated_at`
  ) VALUES
  (
    '#{ability}',
    '2020-11-12 12:25:16.000000',
    '2020-11-12 12:25:16.000000'
  )"
  puts sql
  $database.query(sql)
  puts "Сохранено!".green
  added_count += 1
end

puts "Abilities added: #{added_count}"
