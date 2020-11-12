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
types = pokemons.map { |pokemon| pokemon["types"] }

# p types

types_unique = []

types.each do |type_block|
  type_block.each do |type|
    types_unique << type unless types_unique.include? type
  end
end

added_types = $database.query("SELECT title FROM types").to_a.map { |item| item["title"] }

added_count = 0

types_unique.each do |type|
  next if added_types.include? type

  sql = "INSERT INTO types (
    `title`,
    `created_at`,
    `updated_at`
  ) VALUES
  (
    '#{type}',
    '2020-11-12 12:25:16.000000',
    '2020-11-12 12:25:16.000000'
  )"
  puts sql
  $database.query(sql)
  puts "Сохранено!".green
  added_count += 1
end

puts "Types added: #{added_count}"
