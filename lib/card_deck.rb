require_relative 'playing_card'

class CardDeck

  def initialize
    cardDeck = (1..52).to_a
    @cardDeck = cardDeck
  end

  def newDeck
    @cardDeck
  end

  def cardsLeft
    @cardDeck.length
  end

  def deal
    @cardDeck.pop
    cardsLeft
  end
end
