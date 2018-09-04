require_relative '../lib/playing_card'

describe 'PlayingCard' do
  it 'Should give a numerical rank that coresponds to card number' do
    card = PlayingCard.new
    expect(card.rank("Queen")).to eq 11
  end
end
