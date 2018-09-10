
class WarPlayer
  attr_accessor :hand
  attr_reader   :name

  def initialize(name)
    @name = name
    @hand = []
  end

  def handLength
    @hand.length
  end
end
