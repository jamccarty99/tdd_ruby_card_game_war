require('card_deck')
require('playing_card')
require('war_player')
require('pry')

class WarGame
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
    "jack" => 10,
    "queen" => 11,
    "king" => 12,
    "ace" => 13
  }

  def initialize(player1, player2)
    @player1 = WarPlayer.new(player1)
    @player2 = WarPlayer.new(player2)
  end

  def start
    deck = CardDeck.new
    @newDeck = deck.newDeck
    1.upto(26) do |num|
      @player1.hand << @newDeck.shift

      @player2.hand << @newDeck.shift
    end
    @newDeck
  end

  def play_round
    player1_card = @player1.hand.shift

    player2_card = @player2.hand.shift
    # binding.pry
    if VALUES[player1_card.rank] > VALUES[player2_card.rank]
      roundWinner = @player1.name
      loser_rank = player2_card.rank
      loser_suit = player2_card.suit
      winner_rank = player1_card.rank
      winner_suit = player1_card.suit
    elsif VALUES[player2_card.rank] > VALUES[player1_card.rank]
      roundWinner = @player2.name
    else
      roundWinner = "WAR"
    end

    "#{roundWinner} took #{loser_rank} of #{loser_suit} with #{winner_rank} of #{winner_suit}"
  end

  def war
  end

  def value(card)
    VALUES[card.rank]
  end

  def winner
    @player1.hand.empty? ? winner = @player2 : winner = @player1
    if @player2
      "player2"
    else
      "player1"
    end
  end
end
