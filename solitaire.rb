require 'pp'

# ----------------------------------------
# Models

class Table
  attr_accessor :stock, :waste, :foundations, :tableaus, :draw_count, :tableau_piles, :remaining_deals
  def initialize(cards)
    # Set defaults
    @draw_count       = 3
    @remaining_deals  = 3
    @tableau_piles    = 7
    # Set up foundations
    @foundations = Array.new()
    4.times {
      new_pile = Pile.new()
      new_pile.set_type(:foundation) 
      @foundations << new_pile
    }
    # Set up tableaus
    self.initial_deal(cards)
    # Set up stock
    @stock = Stock.new(cards)
    # Set up waste
    @waste = Waste.new()
  end
  # Deal a new deck
  def initial_deal(cards) # Initial deal
    cards.shuffle!
    @tableaus = Array.new()
    @tableau_piles.times { 
      new_pile = Pile.new()
      new_pile.set_type(:tableau)
      @tableaus << new_pile 
    }
    @tableau_piles.times do |i|
      (i..@tableau_piles-1).each do |c|
        @tableaus[c].push(cards.pop)
      end
      # Flip the top card
      @tableaus[i].last.up = true
    end
  end
  def redeal # Start over
    if @remaining_deals == 0
      puts "No deals left. :("
    else
      @stock = @waste.reverse
      @waste = []
      @remaining_deals -= 1
    end
  end
  # Draw from stack
  # Reset stack
  # Win?
  # Available moves?
  # Export
  def print_ascii
    # Print the foundations
    @foundations.each do | f |
      print "[]".ljust(4) if f.empty?
      print f.top_card unless f.empty?
    end
    print "    "
  
    # Print the top waste card
    print "    " if @waste.empty?
    print @waste.last unless @waste.empty?
  
    # Print the stock
    print "X".ljust(4) if @stock.empty?
    print "[]".ljust(4) unless @stock.empty?
  
    # Add some space
    puts ""
    puts ""
  
    # Print the tableau
    max_depth = @tableaus.max_by { |s| s.count }.count
    max_depth.times do | index |
      @tableaus.each do | stack |
        # We're taller than the current stack
        if (index + 1) > stack.count
          print "    "
          next
        end
        # Check to see if the card is up
        card = stack[index]
        print "[]".ljust(4) unless card.up
        print card if card.up
      end
      puts ""
    end   
  end
end

class Card
  attr_accessor :value, :suit, :up
  def initialize(value, suit)
    @suit  = suit
    @value = value
    @up = false
  end
  def color
    return :red if @suit == 'D' || @suit == 'H'
    return :black
  end
  def symbol
    return 'K' if @value == 13
    return 'Q' if @value == 12
    return 'J' if @value == 11
    return 'A' if @value == 1
    return @value
  end
  def to_s
    "#{@value}#{@suit}".ljust(4)
  end
end

class Pile < Array # Pull apart into foundation and tableau?
  attr_accessor :type
  def set_type(type)
    if type != :tableau && type != :foundation
      raise(ArgumentError, "type is not :tableau or :foundation")
    end
    @type = type
  end
  def top_card
    self.last
  end
  def fits?(candidate)
    if @type == :tableau
      return true if self.count == 0 and candidate.value == 13 # True if empty and King
      return false if self.count == 0 # FALSE if empty and not King
      card = self.top_card
      if candidate.color != card.color and candidate.value == card.value - 1
        return true
      end
    elsif @type == :foundation
      return true if self.count == 0 and candidate.value == 1 # True if empty and Ace
      return false if self.count == 0 # FALSE if empty and not Ace
      card = self.top_card
      if candidate.color == card.color and candidate.value == card.value + 1
        return true
      end
    end
    return false
  end
  def place(card)
    self << card
  end
  def complete?
    return false if self.empty?
    if @type == :tableau
      return true if self.top_card.value == 2
    elsif @type == :foundation
      return true if self.top_card.value == 13
    end
  end
end

class Stock < Array
  attr_accessor :remaining
  def draw(waste, draw_count)
    return false if @remaining == 0
    draw_count.times { waste << self.pop }
    waste.compact!
    return true
  end
end

class Waste < Array
  def top_card
    self.last
  end
end

# ----------------------------------------
# Methods

# Reload the stock from the waste
def reload(stock, waste)
  stock = waste.reverse
  waste = []
  stock.remaining -= 1
end

# Deals the cards to 7 slots
def deal(cards, stacks)
  cards.shuffle!
  table = Tableaus.new()
  stacks.times { 
    new_pile = Pile.new()
    new_pile.set_type(:tableau)
    table << new_pile 
  }
  stacks.times do |i|
    (i..stacks-1).each do |c|
      table[c].push(cards.pop)
    end
    # Flip the top card
    table[i].last.up = true
  end
  return table
end

# Print table
def print_table(foundations, tableaus, stock, waste)
  # Print the foundations
  foundations.each do | f |
    print "[]".ljust(4) if f.empty?
    print f.top_card unless f.empty?
  end
  print "    "
  
  # Print the top waste card
  print "    " if waste.empty?
  print waste.last unless waste.empty?
  
  # Print the stock
  print "X".ljust(4) if stock.empty?
  print "[]".ljust(4) unless stock.empty?
  
  # Add some space
  puts ""
  puts ""
  
  # Print the tableau
  max_depth = tableaus.max_by { |s| s.count }.count
  max_depth.times do | index |
    tableaus.each do | stack |
      # We're taller than the current stack
      if (index + 1) > stack.count
        print "    "
        next
      end
      # Check to see if the card is up
      card = stack[index]
      print "[]".ljust(4) unless card.up
      print card if card.up
      #print stack.last if (index + 1) == stack.count
      #print "  ".ljust(3) if (index + 1) > stack.count
      #print "[]".ljust(3) if (index + 1) < stack.count
    end
    puts ""
  end   
end

# ----------------------------------------
# Main

# Load the deck
@cards = File.readlines('cards.txt').each { |l| l.chomp! }
@cards = @cards.map do | card |
  card_attr = card.split('-')
  Card.new(card_attr[0], card_attr[1])
end

# Create the table
@table = Table.new(@cards)
@table.print_ascii

### Rules
# 1. Always plan an A or 2, immediately.
# 2. Always make the play that frees a downcard, first.
# 3. If there are multiple downcard freeing options, take the largest stack
# 4. Only transfer among tableau to free cards
# 5. Don't clear a tableau unless there's a King present to place in it