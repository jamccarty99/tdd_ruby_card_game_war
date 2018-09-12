require 'socket'
require_relative 'war_socket_game_runner'
require_relative 'war_client'
require_relative 'war_game'
require 'pry'

class WarSocketServer
  def initialize
  end

  def port_number
    3336
  end

  def pending_clients
    @pending_clients ||= []
  end

  def players_in_game
    @players_in_game ||= {}
  end

  def games
    @games ||= []
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def accept_new_client(player_name = "Random Player")
    client = WarClient.new(@server.accept_nonblock, player_name)
    # associate player and client
    pending_clients.push(client)
    client.connection.puts(pending_clients.length.odd? ? "Welcome.  Waiting for another player to join." : "Welcome.  You are about to go to war.")
    client
  rescue IO::WaitReadable, Errno::EINTR
    puts ""
  end

  def create_game_if_possible
    if pending_clients.length > 1
      game = WarGame.new
      games.push(game)
      players_in_game[game] = pending_clients.shift(2)
      game.start
      handInfo(game)
      game
    end
  end

  def gameMessages(game, text)
    players_in_game[game][0].connection.puts(text)
    players_in_game[game][1].connection.puts(text)
  end

  def handInfo(game)
    player1Cards = "#{game.player1.name} has #{game.player1.handLength} cards left. "
    player2Cards = "#{game.player2.name} has #{game.player2.handLength} cards left."
    cardsLeft = player1Cards + player2Cards
    gameMessages(game, cardsLeft)
  end

  def run_game(game)
    # spawn a thread
    threads = []
    Thread.start() do
      game_runner = WarSocketGameRunner.new(game, @players_in_game[game])
      game_runner.start
    end
    # threads << thread1 =
    # threads.each { |thr| thr.join }
  end

  def stop
    @server.close if @server
  end
end
