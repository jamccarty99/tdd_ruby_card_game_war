require_relative '../lib/war_game'

describe 'WarGame' do
  let(:player1_card) { PlayingCard.new("Queen", "Spades") }
  let(:player2_card) { PlayingCard.new("4", "Hearts") }
  let(:tieCard) { PlayingCard.new("Queen", "Hearts") }
  let(:game) { WarGame.new("player1", "player2") }
  let(:deckOf2) { game = [ PlayingCard.new("Queen", "Spades"), PlayingCard.new("4", "Spades") ] }
  let(:deckOf1) { game = [ PlayingCard.new("4", "Hearts") ] }

  before :each do
    game.start()
  end


  describe 'start' do
    it 'Should deal a card to every other player until each has 26 cards' do
      expect(game.player1.hand.length).to eq 26
    end
  end

  describe 'winner' do
    it 'Should be false at the beginning of the game' do
      expect(game.winner).to eq false
    end
  end

  describe 'play_round' do
    it 'Should give a numerical value that coresponds to rank' do
      expect(game.value(player1_card)).to eq 11
    end

    it 'Should play a round of war and determine who won that round' do

      expect(game.play_round(deckOf2, deckOf1)).to eq "player1 won the round"
    end

    it 'Should move both played round cards to the winners hand' do
      game.play_round(deckOf2, deckOf1)
      expect(game.cardsLeft(deckOf2)).to eq 3
    end

    it 'Should play another round if there is a tie and give the spoils' do
      game.compareCards(player1_card, tieCard)
      expect(game.compareCards(player1_card, tieCard)).to eq "WAR"
    end
  end

  describe 'compareCards' do
    it 'Should give the player with the higher card' do
      expect(game.compareCards(player1_card, player2_card)).to eq game.player1
    end

  end

  describe 'winRound' do
    it 'Should display a message with correct info when a player wins a round' do
      expect(game.winRound(game.player1, "round")).to eq "player1 won the round"
    end
  end

  describe 'giveSpoils' do
    it 'should append all the cards in warSpoils to the winners hand' do
      expect(game.giveSpoils(deckOf1, deckOf2)).to eq deckOf1
      expect(deckOf2).to eq []
    end
  end

  describe 'addSpoils' do
    it 'Should add the top card of each hand to the warSpoils array' do
      game.addSpoils(deckOf2, deckOf1)
      expect(deckOf2.length).to eq 1
      expect(deckOf1.length).to eq 0
    end
  end

  describe 'value' do
    it 'Should take a card and give a value based off rank' do
      expect(game.value(tieCard)).to eq 11
    end
  end

end
