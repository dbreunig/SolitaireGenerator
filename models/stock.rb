class Stock < Array
    attr_accessor :remaining
    def draw(waste, draw_count)
      return false if @remaining == 0
      draw_count.times { waste << self.pop }
      waste.compact!
      return true
    end
  end