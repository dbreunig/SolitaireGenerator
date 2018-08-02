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