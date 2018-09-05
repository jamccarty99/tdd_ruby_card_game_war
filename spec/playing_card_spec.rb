require_relative '../lib/playing_card'

describe 'PlayingCard' do
  before do
    @card = PlayingCard.new('ace', 'spades')
  end
  it 'returns suit and rank' do
    ace_spades = PlayingCard.new('ace', 'spades')
    expect(ace_spades.rank).to eq 'ace'
    expect(ace_spades.suit).to eq 'spades'
  end

end
