require_relative '../lib/war_game'

describe 'WarGame' do
  before do
    @game = WarGame.new("player1", "player2")
  end

  it 'Should deal a card to every other player until deck is gone' do
    expect(@game.start).to eq []
  end

  it 'Should determine a winner when one players hand is empty' do
    expect(@game.winner).to eq "player2"
  end

  it 'Should give a numerical value that coresponds to rank' do
    card = PlayingCard.new("queen", "spades")
    expect(@game.value(card)).to eq 11
  end

  it 'Should play a round of war and describe who won that round' do
    @game.start
    expect(@game.play_round).to eq "#{roundWinner} took #{loser_rank} of #{loser_suit} with #{winner_rank} of #{winner_suit}"
  end

end
