require_relative '../lib/war_player'

describe 'WarPlayer' do
  before do
    @player = WarPlayer.new("Joey")
  end
  
  it 'Should contain a name' do
    expect(@player.name).to eq "Joey"
  end

  it 'Should contain an array for each players hand' do
    expect(@player.hand).to eq []
  end
end
