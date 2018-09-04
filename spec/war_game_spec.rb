require_relative '../lib/war_game'

describe 'WarGame' do
  it 'Should shuffle the deck of cards' do
    shuffled = WarGame.new
    expect(shuffled.start).to_not eq (1..52).to_a
  end
  it 'Should deal a card to every other player until deck is gone' do
    dealt = WarGame.new
    expect(dealt.start).to eq []
  end

end
