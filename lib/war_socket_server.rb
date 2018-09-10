require 'socket'
require_relative 'war_socket_game_runner'
require 'pry'

class WarSocketServer
  def initialize
    @allClients = []
  end

  def port_number
    3336
  end

  def pending_clients
    @pending_clients ||= []
  end

  def game_in_progress
    @game_in_progress ||= {}
  end

  def games
    @games ||= []
  end

  def handInfo(game)
    players = game_in_progress[game]
    # players[0].puts("Ready to begin a game of WAR?")
    # players[1].puts("Ready to begin a game of WAR?")
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def accept_new_client(player_name = "Random Player")
    client = @server.accept_nonblock
    # associate player and client
    WarClient.new(client, player_name)
    @allClients.push(client)
    pending_clients.push(client)
    client.puts(pending_clients.length.odd? ? "Welcome.  Waiting for another player to join." : "Welcome.  You are about to go to war.")
  rescue IO::WaitReadable, Errno::EINTR
    puts "No client to accept"
  end

  def create_game_if_possible
    if pending_clients.length > 1
      game = WarGame.new
      games.push(game)
      game_in_progress[game] = pending_clients.shift(2)
      @allClients[0].puts("Ready to begin a game of WAR?")
      @allClients[1].puts("Ready to begin a game of WAR?")
      game.start
      handInfo(game)
    end
  end

  def capture_output(delay=0.1)
    sleep(delay)
    @output = @allClients[0].read_nonblock(1000) # not gets which blocks
    @output = @allClients[1].read_nonblock(1000)
  rescue IO::WaitReadable
    @output = ""
  end

  def run_game(game)
    # spawn a thread
    threads = []
    game_runner = WarSocketGameRunner.new(game, game_in_progress)
    game_runner.start
    # thread1 = Thread.new {  }
    # threads << thread1
    # threads.each { |thr| thr.join }
  end

  def stop
    @server.close if @server
  end
end
