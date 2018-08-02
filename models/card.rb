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