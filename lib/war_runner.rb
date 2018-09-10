require_relative 'war_game'

game = WarGame.new("player1", "player2")
game.start
until game.winner do
  puts game.play_round
end
puts "Winner: #{game.winner.name}"
