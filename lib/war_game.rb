require_relative('card_deck')
require_relative('playing_card')
require_relative('war_player')
require('pry')

class WarGame
  attr_reader :player1, :player2
  VALUES = {
    "2" => 1,
    "3" => 2,
    "4" => 3,
    "5" => 4,
    "6" => 5,
    "7" => 6,
    "8" => 7,
    "9" => 8,
    "10" => 9,
    "Jack" => 10,
    "Queen" => 11,
    "King" => 12,
    "Ace" => 13
  }

  def initialize(player1 = "player1", player2 = "player2")
    @player1 = WarPlayer.new(player1)
    @player2 = WarPlayer.new(player2)
    @warSpoils = []
  end

  def start
    deck = CardDeck.new
    newDeck = deck.shuffle!
    1.upto(26) do
      player1.hand << newDeck.shift
      player2.hand << newDeck.shift
    end
  end

  def play_round(hand1 = player1.hand, hand2 = player2.hand)
    return if winner
    player1_card = hand1.first
    player2_card = hand2.first
    # binding.pry
    compareCards(player1_card, player2_card)
    if @roundWinner == player1
      war?(player1, hand1, hand2)
    elsif @roundWinner == player2
      war?(player2, hand1, hand2)
    else
      4.times do
        addSpoils(hand1, hand2)
      end
      play_round
    end
  end

  def war?(roundWinner, hand1 = player1.hand, hand2 = player2.hand)
    if cardsLeft(@warSpoils) > 0
      addSpoils(hand1, hand2)
      giveSpoils(roundWinner.hand)
      winRound(roundWinner, "war")
    elsif cardsLeft(@warSpoils) == 0
      roundWinner.hand << hand1.shift
      roundWinner.hand << hand2.shift
      winRound(roundWinner, "round")
    end
  end

  def compareCards(player1_card, player2_card)
    if value(player1_card) > value(player2_card)
      @roundWinner = player1
    elsif value(player2_card) > value(player1_card)
      @roundWinner = player2
    else value(player1_card) == value(player2_card)
      @roundWinner = "WAR"
    end
  end

  def value(card)
    VALUES[card.rank]
  end

  def winRound(roundWinner, round)
    "#{roundWinner.name} won the #{round}"
    # by taking #{loser_card} of #{suit} with #{winner_card} of #{suit}
  end

  def giveSpoils(player, spoils = @warSpoils)
    while cardsLeft(spoils) > 0
      player << spoils.shift
    end
    player
  end

  def addSpoils(hand1 = player1.hand, hand2 = player2.hand)
    @warSpoils << hand1.shift
    @warSpoils << hand2.shift
    @warSpoils.compact!
  end

  def cardsLeft(deck)
    deck.length
  end

  def winner
    if cardsLeft(player1.hand) == 0
      player2
    elsif cardsLeft(player2.hand) == 0
      player1
    else
      false
    end
  end
end
