require('card_deck')
require('playing_card')
require('war_player')

class WarGame

  def start
    deck = CardDeck.new
    shuffledFullDeck = deck.newDeck.shuffle
    until shuffledFullDeck == [] do
      shuffledFullDeck.deal
    end
  end

  def play_round
  end

  def winner
  end

end
