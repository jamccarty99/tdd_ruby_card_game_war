require_relative '../lib/card_deck'

describe 'CardDeck' do
  let(:deck) { CardDeck.new }
  before do
    @deck = CardDeck.new
  end

  it 'Should have 52 cards when created' do
    expect(@deck.cardsLeft).to eq 52
  end

  it 'should deal the top card' do
    card = @deck.deal
    expect(card).to_not be_nil
    expect(@deck.cardsLeft).to eq 51
  end

  it 'Should shuffle the deck of cards' do
    expect(@deck.newDeck).to_not be_nil
    expect(@deck.newDeck.shuffle!).to_not eq @deck.newDeck
  end

end
