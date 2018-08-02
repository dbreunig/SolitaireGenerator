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
    def initial_deal(cards) # Initial deal !!! Should be generic!!!
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

    # Reset the stock
    def reset_stock
      if @remaining_deals == 1
        puts "No deals left. :("
      else
        @stock = @waste.reverse
        @waste = []
        @remaining_deals -= 1
      end
    end

    # Draw from stack
    def hit_stock
      # Check if stock has cards left
      if @stock.empty?
        self.reset_stock
      else
        # Pop 3 to waste
        @waste.push(@stock.pop(@draw_count)).flatten!
      end
    end

    # Take the next best move
    def next_best_move
      ### Rules
      # 1. Always plan an A or 2, immediately.
      # 2. Always make the play that frees a downcard, first.
      # 3. If there are multiple downcard freeing options, take the largest stack
      # 4. Only transfer among tableau to free cards
      # 5. Don't clear a tableau unless there's a King present to place in it
    end

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
      print " X".ljust(4) if @stock.empty?
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