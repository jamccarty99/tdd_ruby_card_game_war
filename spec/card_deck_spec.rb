require_relative '../lib/card_deck'

describe 'CardDeck' do
  let(:deck) { CardDeck.new }
  let(:ace) { PlayingCard.new('Ace', 'Spades') }
  let(:player1_card) { PlayingCard.new("Queen", "Spades") }
  let(:player2_card) { PlayingCard.new("4", "Hearts") }
  let(:deckOf2) { game = [ PlayingCard.new("Queen", "Spades"), PlayingCard.new("4", "Spades") ] }

  describe 'cardsLeft' do
    it 'Should have 52 cards when created' do
      expect(deck.cardsLeft(deck.newDeck)).to eq 52
    end
  end



  describe 'shuffle!' do
    it 'Should shuffle the deck of cards' do
      expect(deck.newDeck).to_not be_nil
      expect(deck.shuffledDeck).to_not eq deck.orderedDeck
    end
  end
end
