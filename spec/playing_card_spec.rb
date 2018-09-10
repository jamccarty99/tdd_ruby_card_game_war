require_relative '../lib/playing_card'

describe 'PlayingCard' do

  before do
    @card = PlayingCard.new('Ace', 'Spades')
  end

  it 'returns suit and rank' do
    ace_spades = PlayingCard.new('Ace', 'Spades')
    expect(ace_spades.rank).to eq 'Ace'
    expect(ace_spades.suit).to eq 'Spades'
  end

end
