class PlayingCard

  def initialize
    suit = %w[Clubs, Diamonds, Hearts, Spades]
    @suit = suit
    number = { "2" => 1, "3" => 2, "4" => 3, "5" => 4, "6" => 5, "7" => 6, "8" => 7, "9" => 8, "10" => 9, "Jack" => 10,
      "Queen" => 11, "King" => 12,"Ace" => 12 }
    @number = number
  end

  def rank(cardNumber)
    @number.fetch(cardNumber)
  end

end
