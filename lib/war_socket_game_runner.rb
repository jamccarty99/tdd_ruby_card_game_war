require_relative 'war_game'

class WarSocketGameRunner
  attr_reader :game, :players_in_game

  def initialize(game, players_in_game)
    @game = game
    @players_in_game = players_in_game
  end

  def start
    until winner do
      gameMessages(game, "Ready to begin a game of WAR? Type 'ready'.")
      listen_to_clients
      play_round
    end
    gameMessages(game, "Winner: #{winner}")
  end

  def winner
    if game.winner
      result = game.winner.name
      result
    end
  end

  def play_round
    if ready?
      result = game.play_round
      gameMessages(result)
      player.ready = false
    else
      "Players are not yet ready."
    end
  end

  def gameMessages(text)
    players_in_game.each do |player|
      player.connection.puts(text)
    end
  end

  def listen_to_clients
    @players_in_game.each do |player|
      playerInput = readClient(player)
      player.ready = true if /ready/.match(playerInput)
    end
  end

  def readClient(player)
    begin
      read = player.connection.read_nonblock(1000)
      read
    rescue IO::WaitReadable
      "No message to read"
    end
  end

  def ready?
    @players_in_game.all?(&:ready)
  end

end
