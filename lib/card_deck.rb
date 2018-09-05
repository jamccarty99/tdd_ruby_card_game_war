require_relative 'playing_card'

class CardDeck
  RANK = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "jack", "queen", "king","ace"]
  SUIT = ["clubs", "diamonds", "hearts", "spades"]

  def initialize
    @cardDeck = newDeck
  end

  def newDeck
    newDeck = RANK.map{ |rank| SUIT.map{ |suit| PlayingCard.new(rank, suit) } }.flatten
  end

  def shuffle!
    @deck.shuffle!
  end

  def cardsLeft
    @cardDeck.length
  end

  def deal
    @cardDeck.shift
  end
end
