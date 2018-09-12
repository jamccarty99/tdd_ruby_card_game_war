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

  def play_round
    return if winner
    player1_card = player1.hand.first
    player2_card = player2.hand.first
    compareCards(player1_card, player2_card)
    roundWinner?
  end

  def roundWinner?
    if @roundWinner == player1
      resultOfWar?(player1)
    elsif @roundWinner == player2
      resultOfWar?(player2)
    else
      warRound
    end
  end

  def warRound
    4.times do
      addSpoils
    end
    play_round
  end

  def resultOfWar?(roundWinner)
    if cardsLeft(@warSpoils) > 0
      warResult(roundWinner)
    elsif cardsLeft(@warSpoils) == 0
      roundResult(roundWinner)
    end
  end

  def warResult(roundWinner)
    addSpoils
    giveSpoils(roundWinner.hand)
    declareRoundWinner(roundWinner, "war")
  end

  def roundResult(roundWinner)
    roundWinner.hand << player1.hand.shift
    roundWinner.hand << player2.hand.shift
    declareRoundWinner(roundWinner, "round")
  end

  def declareRoundWinner(roundWinner, round)
    "#{roundWinner.name} won the #{round}"
    # by taking #{loser_card} of #{suit} with #{winner_card} of #{suit}
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



  def giveSpoils(player, spoils = @warSpoils)
    while cardsLeft(spoils) > 0
      player << spoils.shift
    end
    player
  end

  def addSpoils
    @warSpoils << player1.hand.shift
    @warSpoils << player2.hand.shift
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
