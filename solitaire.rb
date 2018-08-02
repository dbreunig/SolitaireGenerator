require 'pp'
require_relative 'models/card.rb'
require_relative 'models/pile.rb'
require_relative 'models/stock.rb'
require_relative 'models/table.rb'
require_relative 'models/waste.rb'

# Load the deck
@cards = File.readlines('cards.txt').each { |l| l.chomp! }
@cards = @cards.map do | card |
  card_attr = card.split('-')
  Card.new(card_attr[0], card_attr[1])
end

# Create the table
@table = Table.new(@cards)
@table.print_ascii
input = ""
while input != "q"
  print("\nWhat next? ")
  input = gets.chomp
  case input
  when "d"
    @table.hit_stock
    @table.print_ascii
  when "p"
    @table.print_ascii
  when "h"
    puts "  'd' - deal from stock"
    puts "  'q' - quit the game"
    puts "  'p' - print the table"
  else
    puts "Type 'h' for help."
  end
end