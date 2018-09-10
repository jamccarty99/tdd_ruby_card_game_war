require_relative '../lib/war_player'

describe 'WarPlayer' do
  let(:player) { WarPlayer.new("Joey") }
  let(:game) { WarGame.new("player1", "player2") }
  let(:start) { game.start }

  it 'Should contain a name' do
    expect(player.name).to eq "Joey"
  end

  it 'Should contain an array for each players hand' do
    expect(player.hand).to eq []
  end

  it 'Should give the length of hand array' do
    start
    expect(player.handLength).to eq 0
  end
end
