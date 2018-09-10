require_relative 'playing_card'

class CardDeck
  attr_reader :cardDeck
  RANK = [ "2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King","Ace" ]
  SUIT = [ "Clubs", "Diamonds", "Hearts", "Spades" ]

  def initialize
    @cardDeck = newDeck
  end

  def newDeck
    RANK.map{ |rank| SUIT.map{ |suit| PlayingCard.new(rank, suit) } }.flatten
  end

  def orderedDeck
    cardDeck.collect { |card| card.to_s }
  end

  def shuffledDeck
    cardDeck.shuffle.collect { |card| card.to_s }
  end

  def deal(deck = @cardDeck)
    deck.shift
  end

  def shuffle!
    cardDeck.shuffle!
  end

  def cardsLeft(deck)
    deck.length
  end
end
